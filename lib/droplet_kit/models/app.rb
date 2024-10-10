# frozen_string_literal: true

module DropletKit
  class AppDomainProgress < BaseModel
    attribute :steps
  end

  class AppDomainSpec < BaseModel
    attribute :domain
    attribute :type
    attribute :wildcard
    attribute :zone
    attribute :minimum_tls_version
  end

  class AppDomainValidation < BaseModel
    attribute :txt_name
    attribute :txt_value
  end

  class AppDomain < BaseModel
    attribute :id
    attribute :phase
    attribute :progress, AppDomainProgress
    attribute :spec, AppDomainSpec
    attribute :validation, [AppDomainValidation]
    attribute :rotate_validation_records
    attribute :certificate_expires_at
  end

  class AppRegion < BaseModel
    attribute :continent
    attribute :data_centers
    attribute :default
    attribute :disabled
    attribute :flag
    attribute :label
    attribute :reason
    attribute :slug
  end

  class AppDedicatedIp < BaseModel
    attribute :ip
    attribute :id
    attribute :status
  end

  class App < BaseModel
    attribute :active_deployment, Deployment
    attribute :created_at
    attribute :default_ingress
    attribute :domains, [AppDomain]
    attribute :id
    attribute :in_progress_deployment, Deployment
    attribute :last_deployment_created_at
    attribute :live_domain
    attribute :live_url
    attribute :live_url_base
    attribute :owner_uuid
    attribute :pending_deployment, Deployment
    attribute :project_id
    attribute :region, AppRegion
    attribute :spec, AppSpec
    attribute :tier_slug
    attribute :updated_at
    attribute :pinned_deployment, Deployment
    attribute :dedicated_ips, [AppDedicatedIp]
    attribute :update_all_source_versions
  end
end
