# frozen_string_literal: true

module DropletKit
  class AppDomainProgressMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDomainProgress
      scoped :read do
        property :steps
      end
    end
  end

  class AppDomainSpecMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDomainSpec
      scoped :read do
        property :domain
        property :type
        property :wildcard
        property :zone
        property :minimum_tls_version
      end
    end
  end

  class AppDomainValidationMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDomainValidation
      scoped :read do
        property :txt_name
        property :txt_value
      end
    end
  end

  class AppDomainMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDomain
      scoped :read do
        property :id
        property :phase
        property :progress, include: AppDomainProgressMapping
        property :spec, include: AppDomainSpecMapping
        property :validation, plural: true, include: AppDomainValidationMapping
        property :rotate_validation_records
        property :certificate_expires_at
      end
    end
  end

  class AppRegionMapping
    include Kartograph::DSL

    kartograph do
      mapping AppRegion
      scoped :read do
        property :continent
        property :data_centers
        property :default
        property :disabled
        property :flag
        property :label
        property :reason
        property :slug
      end
    end
  end

  class AppDedicatedIpMapping
    include Kartograph::DSL

    kartograph do
      mapping AppDedicatedIp
      scoped :read do
        property :ip
        property :id
        property :status
      end
    end
  end

  class AppMapping
    include Kartograph::DSL

    kartograph do
      mapping App
      root_key plural: 'apps', singular: 'app', scopes: [:read]

      property :spec, include: AppSpecMapping, scopes: %i[create update read]
      property :project_id, scopes: %i[create read]
      property :update_all_source_versions, scopes: [:update]
      scoped :read do
        property :active_deployment, include: DeploymentMapping
        property :created_at
        property :default_ingress
        property :domains, plural: true, include: AppDomainMapping
        property :id
        property :in_progress_deployment, include: DeploymentMapping
        property :last_deployment_created_at
        property :live_domain
        property :live_url
        property :live_url_base
        property :owner_uuid
        property :pending_deployment, include: DeploymentMapping
        property :region, include: AppRegionMapping
        property :tier_slug
        property :updated_at
        property :pinned_deployment, include: DeploymentMapping
        property :dedicated_ips, plural: true, include: AppDedicatedIpMapping
      end
    end
  end
end
