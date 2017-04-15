class UserToken
  attr_private_initialize :repo

  def token
    user.token
  end

  def user
    @_user ||= users_with_token.shuffle.detect(-> { hound_user }) do |user|
      can_reach_repository?(user)
    end
  end

  private

  def can_reach_repository?(user)
    GithubApi.new(user.token).repository?(repo.name)
  end

  def hound_user
    User.new(token: Hound::GITHUB_TOKEN)
  end

  def users_with_token
    repo.users_with_token
  end
end
