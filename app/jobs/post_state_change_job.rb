class PostStateChangeJob < ApplicationJob
  queue_as :default

  def perform(post_id, event)
    post = Post.find_by(id: post_id)
    post.send("#{event}!") if post # Вызываем нужное событие
  end
end