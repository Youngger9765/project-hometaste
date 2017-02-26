module CommentsHelper
  def rated_score(score)
    score = score.round(1)
    if score.to_s[-1].to_i >= 5
      (score.to_s[0].to_i + 1).to_i
    elsif score.to_s[-1].to_i > 0
      (score.to_i + 0.5).to_s.gsub('.','_')
    else
      score.to_i
    end
  end
end
