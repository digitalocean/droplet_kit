# frozen_string_literal: true

module DropletKit
  class AppDomainSpec < BaseModel
    attribute :domain
    attribute :type
    attribute :wildcard
    attribute :zone
    attribute :minimum_tls_version
  end

  class AppGitSourceSpec < BaseModel
    attribute :branch
    attribute :repo_clone_url
  end

  class AppGitHubSourceSpec < BaseModel
    attribute :branch
    attribute :deploy_on_push
    attribute :repo
  end

  class AppGitLabSourceSpec < BaseModel
    attribute :branch
    attribute :deploy_on_push
    attribute :repo
  end

  class AppImageDeployOnPush < BaseModel
    attribute :enabled
  end

  class AppImageSourceSpec < BaseModel
    attribute :registry
    attribute :registry_type
    attribute :registry_credentials
    attribute :repository
    attribute :tag
    attribute :digest
    attribute :deploy_on_push, AppImageDeployOnPush
  end

  class AppVariableDefinition < BaseModel
    attribute :key
    attribute :scope
    attribute :type
    attribute :value
  end

  class AppLogDestinationSpecPapertrail < BaseModel
    attribute :endpoint
  end

  class AppLogDestinationSpecDatadog < BaseModel
    attribute :endpoint
    attribute :api_key
  end

  class AppLogDestinationSpecLogtail < BaseModel
    attribute :token
  end

  class OpenSearchBasicAuth < BaseModel
    attribute :username
    attribute :password
  end

  class AppLogDestinationSpecOpenSearch < BaseModel
    attribute :endpoint
    attribute :basic_auth, OpenSearchBasicAuth
    attribute :index_name
    attribute :cluster_name
  end

  class AppLogDestinationSpec < BaseModel
    attribute :name
    attribute :papertrail, AppLogDestinationSpecPapertrail
    attribute :datadog, AppLogDestinationSpecDatadog
    attribute :logtail, AppLogDestinationSpecLogtail
    attribute :open_search, AppLogDestinationSpecOpenSearch
  end

  class AppAutoscalingSpecMetricCPU < BaseModel
    attribute :percent
  end

  class AppAutoscalingSpecMetrics < BaseModel
    attribute :cpu, AppAutoscalingSpecMetricCPU
  end

  class AppAutoscalingSpec < BaseModel
    attribute :min_instance_count
    attribute :max_instance_count
    attribute :metrics, AppAutoscalingSpecMetrics
  end

  class AppServiceSpecHealthCheck < BaseModel
    attribute :failure_threshold
    attribute :port
    attribute :http_path
    attribute :initial_delay_seconds
    attribute :period_seconds
    attribute :success_threshold
    attribute :timeout_seconds
  end

  class AppServiceSpecTermination < BaseModel
    attribute :drain_seconds
    attribute :grace_period_seconds
  end

  class AppServiceSpec < BaseModel
    attribute :name
    attribute :git, AppGitSourceSpec
    attribute :github, AppGitHubSourceSpec
    attribute :gitlab, AppGitLabSourceSpec
    attribute :image, AppImageSourceSpec
    attribute :dockerfile_path
    attribute :build_command
    attribute :run_command
    attribute :source_dir
    attribute :envs, [AppVariableDefinition]
    attribute :environment_slug
    attribute :log_destinations, [AppLogDestinationSpec]
    attribute :instance_count
    attribute :instance_size_slug
    attribute :autoscaling, AppAutoscalingSpec
    attribute :health_check, AppServiceSpecHealthCheck
    attribute :http_port
    attribute :internal_ports
    attribute :termination, AppServiceSpecTermination
  end

  class AppStaticSiteSpec < BaseModel
    attribute :name
    attribute :git, AppGitSourceSpec
    attribute :github, AppGitHubSourceSpec
    attribute :gitlab, AppGitLabSourceSpec
    attribute :image, AppImageSourceSpec
    attribute :dockerfile_path
    attribute :build_command
    attribute :run_command
    attribute :source_dir
    attribute :envs, [AppVariableDefinition]
    attribute :environment_slug
    attribute :log_destinations, [AppLogDestinationSpec]
    attribute :index_document
    attribute :error_document
    attribute :catchall_document
    attribute :output_dir
  end

  class AppJobSpecTermination < BaseModel
    attribute :grace_period_seconds
  end

  class AppJobSpec < BaseModel
    attribute :name
    attribute :git, AppGitSourceSpec
    attribute :github, AppGitHubSourceSpec
    attribute :gitlab, AppGitLabSourceSpec
    attribute :image, AppImageSourceSpec
    attribute :dockerfile_path
    attribute :build_command
    attribute :run_command
    attribute :source_dir
    attribute :envs, [AppVariableDefinition]
    attribute :environment_slug
    attribute :log_destinations, [AppLogDestinationSpec]
    attribute :instance_count
    attribute :instance_size_slug
    attribute :autoscaling, AppAutoscalingSpec
    attribute :kind
    attribute :termination, AppJobSpecTermination
  end

  class AppWorkerSpecTermination < BaseModel
    attribute :grace_period_seconds
  end

  class AppWorkerSpec < BaseModel
    attribute :name
    attribute :git, AppGitSourceSpec
    attribute :github, AppGitHubSourceSpec
    attribute :gitlab, AppGitLabSourceSpec
    attribute :image, AppImageSourceSpec
    attribute :dockerfile_path
    attribute :build_command
    attribute :run_command
    attribute :source_dir
    attribute :envs, [AppVariableDefinition]
    attribute :environment_slug
    attribute :log_destinations, [AppLogDestinationSpec]
    attribute :instance_count
    attribute :instance_size_slug
    attribute :autoscaling, AppAutoscalingSpec
    attribute :termination, AppWorkerSpecTermination
  end

  class AppAlertSpec < BaseModel
    attribute :rule
    attribute :disabled
    attribute :operator
    attribute :value
    attribute :window
  end

  class AppFunctionSpec < BaseModel
    attribute :name
    attribute :source_dir
    attribute :alerts, [AppAlertSpec]
    attribute :envs, [AppVariableDefinition]
    attribute :log_destinations, [AppLogDestinationSpec]
  end

  class AppDatabaseSpec < BaseModel
    attribute :cluster_name
    attribute :db_name
    attribute :db_user
    attribute :engine
    attribute :name
    attribute :production
    attribute :version
  end

  class AppIngressSpecRuleStringMatch < BaseModel
    attribute :prefix
  end

  class AppIngressSpecRuleMatch < BaseModel
    attribute :path, AppIngressSpecRuleStringMatch
  end

  class AppStringMatch < BaseModel
    attribute :exact
    attribute :regex
  end

  class AppCorsPolicy < BaseModel
    attribute :allow_origins, [AppStringMatch]
    attribute :allow_methods
    attribute :allow_headers
    attribute :expose_headers
    attribute :max_age
    attribute :allow_credentials
  end

  class AppIngressSpecRuleRoutingComponent < BaseModel
    attribute :name
    attribute :preserve_path_prefix
    attribute :rewrite
  end

  class AppIngressSpecRuleRoutingRedirect < BaseModel
    attribute :uri
    attribute :authority
    attribute :port
    attribute :scheme
    attribute :redirect_code
  end

  class AppIngressSpecRule < BaseModel
    attribute :match, AppIngressSpecRuleMatch
    attribute :cors, AppCorsPolicy
    attribute :component, AppIngressSpecRuleRoutingComponent
    attribute :redirect, AppIngressSpecRuleRoutingRedirect
  end

  class AppIngressSpec < BaseModel
    attribute :rules, [AppIngressSpecRule]
  end

  class AppEgressSpec < BaseModel
    attribute :type
  end

  class AppSpec < BaseModel
    attribute :name
    attribute :region
    attribute :domains, [AppDomainSpec]
    attribute :services, [AppServiceSpec]
    attribute :static_sites, [AppStaticSiteSpec]
    attribute :jobs, [AppJobSpec]
    attribute :workers, [AppWorkerSpec]
    attribute :functions, [AppFunctionSpec]
    attribute :databases, [AppDatabaseSpec]
    attribute :ingress, AppIngressSpec
    attribute :egress, AppEgressSpec
  end
end
