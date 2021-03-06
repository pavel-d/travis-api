module Travis::API::V3
  class Queries::Request < Query
    params  :id, :message, :branch, :config, :token, prefix: :request

    def find
      relation = Models::Request
      relation = relation.includes(raw_configurations: :raw_config) if includes?('request.raw_configs')
      relation = relation.includes(:config) if includes?('request.config')
      return relation.find_by_id(id) if id
      raise WrongParams, 'missing request.id'.freeze
    end

    def schedule(repository, user)
      raise ServerError, 'repository does not have a github_id'.freeze unless repository.github_id
      raise WrongParams, 'missing user'.freeze                         unless user and user.id

      record = create_request(repository)

      payload = {
        repository: { id: repository.github_id, owner_name: repository.owner_name, name: repository.name },
        user:       { id: user.id },
        id:         record.id,
        message:    message,
        branch:     branch || repository.default_branch_name,
        config:     config || {}
      }

      ::Travis::API::Sidekiq.gatekeeper(
        type: 'api'.freeze,
        credentials: { token: token },
        payload: JSON.dump(payload)
      )
      payload
    end

    private

    def create_request(repository)
      Models::Request.create!(
        event_type: :api,
        state:      :pending,
        repository: repository,
        owner:      repository.owner,
        private:    repository.private
      )
    end
  end
end
