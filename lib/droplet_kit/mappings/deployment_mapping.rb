# frozen_string_literal: true

module DropletKit
  class DeploymentJobMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentJob
      scoped :read do
        property :name
        property :source_commit_hash
      end
    end
  end

  class DeploymentFunctionMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentFunction
      scoped :read do
        property :name
        property :source_commit_hash
        property :namespace
      end
    end
  end

  class DeploymentProgressStepReasonMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentProgressStepReason
      scoped :read do
        property :code
        property :message
      end
    end
  end

  class DeploymentProgressStepMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentProgressStep
      scoped :read do
        property :component_name
        property :ended_at
        property :message_base
        property :name
        property :reason, include: DeploymentProgressStepReasonMapping
        property :started_at
        property :status
        property :steps
      end
    end
  end

  class DeploymentProgressMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentProgress
      scoped :read do
        property :error_steps
        property :pending_steps
        property :running_steps
        property :steps, plural: true, include: DeploymentProgressStepMapping
        property :success_steps
        property :summary_steps, plural: true, include: DeploymentProgressStepMapping
        property :total_steps
      end
    end
  end

  class DeploymentServiceMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentService
      scoped :read do
        property :name
        property :source_commit_hash
      end
    end
  end

  class DeploymentStaticSiteMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentStaticSite
      scoped :read do
        property :name
        property :source_commit_hash
      end
    end
  end

  class DeploymentWorkerMapping
    include Kartograph::DSL

    kartograph do
      mapping DeploymentWorker
      scoped :read do
        property :name
        property :source_commit_hash
      end
    end
  end

  class DeploymentMapping
    include Kartograph::DSL

    kartograph do
      mapping Deployment
      scoped :read do
        property :cause
        property :cloned_from
        property :created_at
        property :id
        property :jobs, plural: true, include: DeploymentJobMapping
        property :functions, plural: true, include: DeploymentFunctionMapping
        property :phase
        property :phase_last_updated_at
        property :progress, include: DeploymentProgressMapping
        property :services, plural: true, include: DeploymentServiceMapping
        property :spec, include: AppSpecMapping
        property :static_sites, plural: true, include: DeploymentStaticSiteMapping
        property :tier_slug
        property :updated_at
        property :workers, plural: true, include: DeploymentWorkerMapping
      end
    end
  end
end
