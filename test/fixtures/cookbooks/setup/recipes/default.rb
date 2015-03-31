
if Chef::Platform.find_provider_for_node(node, :service) == Chef::Provider::Service::Systemd
  include_recipe 'hekad::systemd_journal'

  heka_config 'elasticsearch_json_encoder' do
    config({
      "ESJsonEncoder" => {
        "es_index_from_timestamp" => true
      }
    })
  end

  heka_config 'systemd_journal_file_output' do
    config({
      "SystemdJournalFileOutput" => {
                   "type" => "FileOutput",
        "message_matcher" => "Type == 'systemd_journal'",
                   "path" => "/var/log/hekad-journal.log",
            "flush_count" => 100,
         "flush_operator" => "OR",
                "encoder" => "ESJsonEncoder"
      }
    })
    notifies :restart, 'service[hekad]', :delayed
  end
end
