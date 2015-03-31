
if Chef::Platform.find_provider_for_node(node, :service) == Chef::Provider::Service::Systemd


  service 'systemd-journald'

  ruby_block 'configure journal to forward to syslog' do
    block do
      fe = Chef::Util::FileEdit.new("/etc/systemd/journald.conf")
      fe.insert_line_if_no_match(/ForwardToSyslog=yes/, "ForwardToSyslog=yes")
      fe.write_file
    end
    notifies :restart, 'service[systemd-journald]', :immediately
  end

  include_recipe 'hekad::journald'

  heka_config 'elasticsearch_json_encoder' do
    config({
      "ESJsonEncoder" => {
        "es_index_from_timestamp" => true
      }
    })
    notifies :restart, 'service[hekad]', :delayed
  end

  heka_config 'journald_file_output' do
    config({
      "journal_file_output" => {
                   "type" => "FileOutput",
        "message_matcher" => "Type == 'journald_syslog'",
                   "path" => "/var/log/hekad-journal.log",
            "flush_count" => 100,
         "flush_operator" => "OR",
                "encoder" => "ESJsonEncoder"
      }
    })
    notifies :restart, 'service[hekad]', :delayed
  end

  # Generate a searchable log-message
  service 'crond' do
    action :enable, :restart
  end
end
