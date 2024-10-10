# frozen_string_literal: true

module DropletKit
  class DeploymentJob < BaseModel
    attribute :name
    attribute :source_commit_hash
  end

  class DeploymentFunction < BaseModel
    attribute :name
    attribute :source_commit_hash
    attribute :namespace
  end

  class DeploymentProgressStepReason < BaseModel
    attribute :code
    attribute :message
  end

  class DeploymentProgressStep < BaseModel
    attribute :component_name
    attribute :ended_at
    attribute :message_base
    attribute :name
    attribute :reason, DeploymentProgressStepReason
    attribute :started_at
    attribute :status
    attribute :steps
  end

  class DeploymentProgress < BaseModel
    attribute :error_steps
    attribute :pending_steps
    attribute :running_steps
    attribute :steps, [DeploymentProgressStep]
    attribute :success_steps
    attribute :summary_steps, [DeploymentProgressStep]
    attribute :total_steps
  end

  class DeploymentService < BaseModel
    attribute :name
    attribute :source_commit_hash
  end

  class DeploymentStaticSite < BaseModel
    attribute :name
    attribute :source_commit_hash
  end

  class DeploymentWorker < BaseModel
    attribute :name
    attribute :source_commit_hash
  end

  class Deployment < BaseModel
    attribute :cause
    attribute :cloned_from
    attribute :created_at
    attribute :id
    attribute :jobs, [DeploymentJob]
    attribute :functions, [DeploymentFunction]
    attribute :phase
    attribute :phase_last_updated_at
    attribute :progress, DeploymentProgress
    attribute :services, [DeploymentService]
    attribute :spec, AppSpec
    attribute :static_sites, [DeploymentStaticSite]
    attribute :tier_slug
    attribute :updated_at
    attribute :workers, [DeploymentWorker]
  end
end
