class CommentsChannel < ApplicationCable::Channel
  def follow_comments(data)
    stream_from "question_#{data['question_id']}_comments"
  end
end
