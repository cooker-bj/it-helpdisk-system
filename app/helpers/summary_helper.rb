module SummaryHelper
  def build_id(first,last)
    first.strftime("%Y%m%d")+last.strftime("%Y%m%d")
  end
end
