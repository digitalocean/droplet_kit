# frozen_string_literal: true

module DropletKit
  class AppDomainSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDomainSpec
      scoped :read, :create, :update do
        property :domain
        property :type
        property :wildcard
        property :zone
        property :minimum_tls_version
      end
    end
  end

  class AppGitSourceSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppGitSourceSpec
      scoped :read, :create, :update do
        property :branch
        property :repo_clone_url
      end
    end
  end

  class AppGitHubSourceSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppGitHubSourceSpec
      scoped :read, :create, :update do
        property :branch
        property :deploy_on_push
        property :repo
      end
    end
  end

  class AppGitLabSourceSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppGitLabSourceSpec
      scoped :read, :create, :update do
        property :branch
        property :deploy_on_push
        property :repo
      end
    end
  end

  class AppImageDeployOnPushMapping
    include Kartograph::DSL

    kartograph do
      mapping AppImageDeployOnPush
      scoped :read, :create, :update do
        property :enabled
      end
    end
  end

  class AppImageSourceSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppImageSourceSpec
      scoped :read, :create, :update do
        property :registry
        property :registry_type
        property :registry_credentials
        property :repository
        property :tag
        property :digest
        property :deploy_on_push, include: AppImageDeployOnPushMapping
      end
    end
  end

  class AppVariableDefinitionMapping
    include Kartograph::DSL

    kartograph do
      mapping AppVariableDefinition
      scoped :read, :create, :update do
        property :key
        property :scope
        property :type
        property :value
      end
    end
  end

  class AppLogDestinationSpecPapertrailMapping
    include Kartograph::DSL

    kartograph do
      mapping AppLogDestinationSpecPapertrail
      scoped :read, :create, :update do
        property :endpoint
      end
    end
  end

  class AppLogDestinationSpecDatadogMapping
    include Kartograph::DSL

    kartograph do
      mapping AppLogDestinationSpecDatadog
      scoped :read, :create, :update do
        property :endpoint
        property :api_key
      end
    end
  end

  class AppLogDestinationSpecLogtailMapping
    include Kartograph::DSL

    kartograph do
      mapping AppLogDestinationSpecLogtail
      scoped :read, :create, :update do
        property :token
      end
    end
  end

  class OpenSearchBasicAuthMapping
    include Kartograph::DSL

    kartograph do
      mapping OpenSearchBasicAuth
      scoped :read, :create, :update do
        property :username
        property :password
      end
    end
  end

  class AppLogDestinationSpecOpenSearchMapping
    include Kartograph::DSL

    kartograph do
      mapping AppLogDestinationSpecOpenSearch
      scoped :read, :create, :update do
        property :endpoint
        property :basic_auth, include: OpenSearchBasicAuthMapping
        property :index_name
        property :cluster_name
      end
    end
  end

  class AppLogDestinationSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppLogDestinationSpec
      scoped :read, :create, :update do
        property :name
        property :papertrail, include: AppLogDestinationSpecPapertrailMapping
        property :datadog, include: AppLogDestinationSpecDatadogMapping
        property :logtail, include: AppLogDestinationSpecLogtailMapping
        property :open_search, include: AppLogDestinationSpecOpenSearchMapping
      end
    end
  end

  class AppAutoscalingSpecMetricCPUMapping
    include Kartograph::DSL

    kartograph do
      mapping AppAutoscalingSpecMetricCPU
      scoped :read, :create, :update do
        property :percent
      end
    end
  end

  class AppAutoscalingSpecMetricsMapping
    include Kartograph::DSL

    kartograph do
      mapping AppAutoscalingSpecMetrics
      scoped :read, :create, :update do
        property :cpu, include: AppAutoscalingSpecMetricCPUMapping
      end
    end
  end

  class AppAutoscalingSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppAutoscalingSpec
      scoped :read, :create, :update do
        property :min_instance_count
        property :max_instance_count
        property :metrics, include: AppAutoscalingSpecMetricsMapping
      end
    end
  end

  class AppServiceSpecHealthCheckMapping
    include Kartograph::DSL

    kartograph do
      mapping AppServiceSpecHealthCheck
      scoped :read, :create, :update do
        property :failure_threshold
        property :port
        property :http_path
        property :initial_delay_seconds
        property :period_seconds
        property :success_threshold
        property :timeout_seconds
      end
    end
  end

  class AppServiceSpecTerminationMapping
    include Kartograph::DSL

    kartograph do
      mapping AppServiceSpecTermination
      scoped :read, :create, :update do
        property :drain_seconds
        property :grace_period_seconds
      end
    end
  end

  class AppServiceSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppServiceSpec
      scoped :read, :create, :update do
        property :name
        property :git, include: AppGitSourceSpecMapping
        property :github, include: AppGitHubSourceSpecMapping
        property :gitlab, include: AppGitLabSourceSpecMapping
        property :image, include: AppImageSourceSpecMapping
        property :dockerfile_path
        property :build_command
        property :run_command
        property :source_dir
        property :envs, plural: true, include: AppVariableDefinitionMapping
        property :environment_slug
        property :log_destinations, plural: true, include: AppLogDestinationSpecMapping
        property :instance_count
        property :instance_size_slug
        property :autoscaling, include: AppAutoscalingSpecMapping
        property :health_check, include: AppServiceSpecHealthCheckMapping
        property :http_port
        property :internal_ports
        property :termination, include: AppServiceSpecTerminationMapping
      end
    end
  end

  class AppStaticSiteSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppStaticSiteSpec
      scoped :read, :create, :update do
        property :name
        property :git, include: AppGitSourceSpecMapping
        property :github, include: AppGitHubSourceSpecMapping
        property :gitlab, include: AppGitLabSourceSpecMapping
        property :image, include: AppImageSourceSpecMapping
        property :dockerfile_path
        property :build_command
        property :run_command
        property :source_dir
        property :envs, plural: true, include: AppVariableDefinitionMapping
        property :environment_slug
        property :log_destinations, plural: true, include: AppLogDestinationSpecMapping
        property :index_document
        property :error_document
        property :catchall_document
        property :output_dir
      end
    end
  end

  class AppJobSpecTerminationMapping
    include Kartograph::DSL

    kartograph do
      mapping AppJobSpecTermination
      scoped :read, :create, :update do
        property :grace_period_seconds
      end
    end
  end

  class AppJobSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppJobSpec
      scoped :read, :create, :update do
        property :name
        property :git, include: AppGitSourceSpecMapping
        property :github, include: AppGitHubSourceSpecMapping
        property :gitlab, include: AppGitLabSourceSpecMapping
        property :image, include: AppImageSourceSpecMapping
        property :dockerfile_path
        property :build_command
        property :run_command
        property :source_dir
        property :envs, plural: true, include: AppVariableDefinitionMapping
        property :environment_slug
        property :log_destinations, plural: true, include: AppLogDestinationSpecMapping
        property :instance_count
        property :instance_size_slug
        property :autoscaling, include: AppAutoscalingSpecMapping
        property :kind
        property :termination, include: AppJobSpecTerminationMapping
      end
    end
  end

  class AppWorkerSpecTerminationMapping
    include Kartograph::DSL

    kartograph do
      mapping AppWorkerSpecTermination
      scoped :read, :create, :update do
        property :grace_period_seconds
      end
    end
  end

  class AppWorkerSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppWorkerSpec
      scoped :read, :create, :update do
        property :name
        property :git, include: AppGitSourceSpecMapping
        property :github, include: AppGitHubSourceSpecMapping
        property :gitlab, include: AppGitLabSourceSpecMapping
        property :image, include: AppImageSourceSpecMapping
        property :dockerfile_path
        property :build_command
        property :run_command
        property :source_dir
        property :envs, plural: true, include: AppVariableDefinitionMapping
        property :environment_slug
        property :log_destinations, plural: true, include: AppLogDestinationSpecMapping
        property :instance_count
        property :instance_size_slug
        property :autoscaling, include: AppAutoscalingSpecMapping
        property :termination, include: AppWorkerSpecTerminationMapping
      end
    end
  end

  class AppAlertSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppAlertSpec
      scoped :read, :create, :update do
        property :rule
        property :disabled
        property :operator
        property :value
        property :window
      end
    end
  end

  class AppFunctionSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppFunctionSpec
      scoped :read, :create, :update do
        property :name
        property :source_dir
        property :alerts, plural: true, include: AppAlertSpecMapping
        property :envs, plural: true, include: AppVariableDefinitionMapping
        property :log_destinations, plural: true, include: AppLogDestinationSpecMapping
      end
    end
  end

  class AppDatabaseSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDatabaseSpec
      scoped :read, :create, :update do
        property :cluster_name
        property :db_name
        property :db_user
        property :engine
        property :name
        property :production
        property :version
      end
    end
  end

  class AppIngressSpecRuleStringMatchMapping
    include Kartograph::DSL

    kartograph do
      mapping AppIngressSpecRuleStringMatch
      scoped :read, :create, :update do
        property :prefix
      end
    end
  end

  class AppIngressSpecRuleMatchMapping
    include Kartograph::DSL

    kartograph do
      mapping AppIngressSpecRuleMatch
      scoped :read, :create, :update do
        property :path, include: AppIngressSpecRuleStringMatchMapping
      end
    end
  end

  class AppStringMatchMapping
    include Kartograph::DSL

    kartograph do
      mapping AppStringMatch
      scoped :read, :create, :update do
        property :exact
        property :regex
      end
    end
  end

  class AppCorsPolicyMapping
    include Kartograph::DSL

    kartograph do
      mapping AppCorsPolicy
      scoped :read, :create, :update do
        property :allow_origins, plural: true, include: AppStringMatchMapping
        property :allow_methods
        property :allow_headers
        property :expose_headers
        property :max_age
        property :allow_credentials
      end
    end
  end

  class AppIngressSpecRuleRoutingComponentMapping
    include Kartograph::DSL

    kartograph do
      mapping AppIngressSpecRuleRoutingComponent
      scoped :read, :create, :update do
        property :name
        property :preserve_path_prefix
        property :rewrite
      end
    end
  end

  class AppIngressSpecRuleRoutingRedirectMapping
    include Kartograph::DSL

    kartograph do
      mapping AppIngressSpecRuleRoutingRedirect
      scoped :read, :create, :update do
        property :uri
        property :authority
        property :port
        property :scheme
        property :redirect_code
      end
    end
  end

  class AppIngressSpecRuleMapping
    include Kartograph::DSL

    kartograph do
      mapping AppIngressSpecRule
      scoped :read, :create, :update do
        property :match, include: AppIngressSpecRuleMatchMapping
        property :cors, include: AppCorsPolicyMapping
        property :component, include: AppIngressSpecRuleRoutingComponentMapping
        property :redirect, include: AppIngressSpecRuleRoutingRedirectMapping
      end
    end
  end

  class AppIngressSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppIngressSpec
      scoped :read, :create, :update do
        property :rules, plural: true, include: AppIngressSpecRuleMapping
      end
    end
  end

  class AppEgressSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppEgressSpec
      scoped :read, :create, :update do
        property :type
      end
    end
  end

  class AppSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppSpec
      scoped :read, :create, :update do
        property :name
        property :region
        property :domains, plural: true, include: AppDomainSpecMapping
        property :services, plural: true, include: AppServiceSpecMapping
        property :static_sites, plural: true, include: AppStaticSiteSpecMapping
        property :jobs, plural: true, include: AppJobSpecMapping
        property :workers, plural: true, include: AppWorkerSpecMapping
        property :functions, plural: true, include: AppFunctionSpecMapping
        property :databases, plural: true, include: AppDatabaseSpecMapping
        property :ingress, include: AppIngressSpecMapping
        property :egress, include: AppEgressSpecMapping
      end
    end
  end
end
