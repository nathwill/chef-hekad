#
# Cookbook Name:: hekad
# Library:: Heka::Init
#
# Copyright 2016 Nathan Williams
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Heka
  module Init
    def upstart?
      File.executable?('/sbin/initctl')
    end

    def systemd?
      ::File.exist?('/proc/1/comm') &&
        ::IO.read('/proc/1/comm').chomp == 'systemd'
    end

    module_function :upstart?, :systemd?
  end

  module Global
    OPTIONS ||= {
      cpuprof: { kind_of: String },
      max_message_loops: { kind_of: Integer },
      max_process_inject: { kind_of: Integer },
      max_process_duration: { kind_of: Integer },
      max_timer_inject: { kind_of: Integer },
      max_pack_idle: { kind_of: String },
      maxprocs: { kind_of: Integer },
      memprof: { kind_of: String },
      poolsize: { kind_of: Integer },
      plugin_chansize: { kind_of: Integer },
      base_dir: { kind_of: String },
      share_dir: { kind_of: String },
      sample_denominator: { kind_of: Integer },
      pid_file: { kind_of: String },
      hostname: { kind_of: String },
      max_message_size: { kind_of: Integer },
      log_flags: { kind_of: Integer },
      full_buffer_max_retries: { kind_of: Integer }
    }.freeze
  end

  module Input
    OPTIONS ||= {
      decoder: { kind_of: String },
      synchronous_decode: { kind_of: [TrueClass, FalseClass] },
      send_decode_failures: { kind_of: [TrueClass, FalseClass] },
      can_exit: { kind_of: [TrueClass, FalseClass] },
      splitter: { kind_of: String },
      log_decode_failures: { kind_of: [TrueClass, FalseClass] }
    }.freeze
  end

  module Splitter
    OPTIONS ||= {
      keep_truncated: { kind_of: [TrueClass, FalseClass] },
      use_message_bytes: { kind_of: [TrueClass, FalseClass] },
      min_buffer_size: { kind_of: Integer },
      deliver_incomplete_final: { kind_of: [TrueClass, FalseClass] }
    }.freeze
  end

  module Decoder
    OPTIONS ||= {}.freeze
  end

  module Filter
    OPTIONS ||= {
      message_matcher: { kind_of: String },
      message_signer: { kind_of: String },
      ticker_interval: { kind_of: Integer },
      can_exit: { kind_of: [TrueClass, FalseClass] },
      use_buffering: { kind_of: [TrueClass, FalseClass] }
    }.freeze
  end

  module Encoder
    OPTIONS ||= {}.freeze
  end

  module Output
    OPTIONS ||= {
      message_matcher: { kind_of: String },
      message_signer: { kind_of: String },
      encoder: { kind_of: String },
      use_framing: { kind_of: [TrueClass, FalseClass] },
      can_exit: { kind_of: [TrueClass, FalseClass] },
      use_buffering: { kind_of: [TrueClass, FalseClass] }
    }.freeze
  end

  module Sandbox
    OPTIONS ||= {
      script_type: { kind_of: String },
      filename: { kind_of: String },
      preserve_data: { kind_of: [TrueClass, FalseClass] },
      memory_limit: { kind_of: Integer },
      instruction_limit: { kind_of: Integer },
      output_limit: { kind_of: Integer },
      module_directory: { kind_of: String },
      sandbox_config: { kind_of: Hash }
    }.freeze
  end

  module Restart
    OPTIONS ||= {
      max_jitter: { kind_of: String },
      max_delay: { kind_of: String },
      delay: { kind_of: String },
      max_retries: { kind_of: Integer }
    }.freeze
  end

  module Buffering
    OPTIONS ||= {
      max_file_size: { kind_of: Integer },
      max_buffer_size: { kind_of: Integer },
      full_action: { kind_of: String, equal_to: %w[shutdown drop block] },
      cursor_update_count: { kind_of: Integer }
    }.freeze
  end

  module TLS
    VERSIONS ||= %w[SSL30 TLS10 TLS11 TLS12].freeze

    CIPHERS ||= %w[
      RSA_WITH_RC4_128_SHA
      RSA_WITH_3DES_EDE_CBC_SHA
      RSA_WITH_AES_128_CBC_SHA
      RSA_WITH_AES_256_CBC_SHA
      ECDHE_ECDSA_WITH_RC4_128_SHA
      ECDHE_ECDSA_WITH_AES_128_CBC_SHA
      ECDHE_ECDSA_WITH_AES_256_CBC_SHA
      ECDHE_RSA_WITH_RC4_128_SHA
      ECDHE_RSA_WITH_3DES_EDE_CBC_SHA
      ECDHE_RSA_WITH_AES_128_CBC_SHA
      ECDHE_RSA_WITH_AES_256_CBC_SHA
      ECDHE_RSA_WITH_AES_128_GCM_SHA256
      ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
    ].freeze

    OPTIONS ||= {
      server_name: { kind_of: String },
      cert_file: { kind_of: String },
      key_file: { kind_of: String },
      client_auth: {
        kind_of: String,
        equal_to: %w[
          NoClientCert
          RequestClientCert
          RequireAnyClientCert
          VerifyClientCertIfGiven
          RequireAndVerifyClientCert
        ]
      },
      ciphers: {
        kind_of: Array,
        callbacks: {
          'contains only permitted ciphers' => lambda do |spec|
            spec.all? { |cipher| CIPHERS.include?(cipher) }
          end
        }
      },
      insecure_skip_verify: { kind_of: [TrueClass, FalseClass] },
      prefer_server_ciphers: { kind_of: [TrueClass, FalseClass] },
      session_tickets_disabled: { kind_of: [TrueClass, FalseClass] },
      session_ticket_key: { kind_of: String },
      min_version: { kind_of: String, equal_to: VERSIONS },
      max_version: { kind_of: String, equal_to: VERSIONS },
      client_cafile: { kind_of: String },
      root_cafile: { kind_of: String }
    }.freeze
  end
end
