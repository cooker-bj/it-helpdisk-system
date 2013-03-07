#--- encoding: UTF-8
class SummaryController < ApplicationController
before_filter :login_required,:has_right?
  def index
    unless params[:start].nil?
    @start=Time.local(params[:start][:year],params[:start][:month],params[:start][:day])
    @last=Time.local(params[:end][:year],params[:end][:month],params[:end][:day],24 )
   else
      @start=(Time.now-6.days)
      @last=(Time.now)

    end
    @data=Hash.new()


    @data[:weekly]=ItCase.weekly_case_number(@last)
    @data[:monthly]=ItCase.monthly_case_number(@last)
    @data[:casetype]=ItCase.summary_by_type(@start,@last)
    @data[:staff]=Task.summary_by_staff(@start,@last)
    @data[:waitting_time]=ItCase.summary_average_waitting_by_zone(@start,@last)
    @data[:average_workon]=ItCase.summary_average_workon_by_type(@start,@last)
    @data[:average_workon_by_staff]=Task.summary_average_workon_by_staff(@start,@last)
    @data[:rank]=ItCase.summary_by_rank(@start,@last)
    @data[:rank_by_staff]=ItCase.summary_rank_by_staff(@start,@last)
    @data[:callin]=ItCase.summary_callin_type(@start,@last)
  end



  def weekly_graph
    id=params[:id]
    start,last=translate(id)
    data=ItCase.weekly_case_number(last)
    g=Graph.new(data)
    img=g.oneline("周工单变动图")
    send_data( img.to_blob,:disposition => 'inline',
                   :type => 'image/png',
                     :filename => "weekly_static.png")

  end


  def  monthly_graph
    id=params[:id]
    start,last=translate(id)
    data=ItCase.monthly_case_number(last)
    g=Graph.new(data)
    img=g.oneline("月度工单变动图")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "monthly_static.png")
  end

  def type_graph
    id=params[:id]
    start,last=translate(id)
    data=ItCase.summary_by_type(start,last)
    g=Graph.new(data)
    img=g.pie("故障分类")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "type_static.png")
  end


  def workload_graph
    id=params[:id]
    start,last=translate(id)
    data=Task.summary_by_staff(start,last)

    g=Graph.new(data)
    img=g.twobar("工作量统计",:total,:upgrade)
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "work_load_static.png")
  end

  def waitting_graph

    start,last=translate(params[:id])
    data=ItCase.summary_average_waitting_by_zone(start,last)
    g=Graph.new(data)
    img=g.bar("各工作区工单等待处理时间")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "waitting.png")
  end


  def workon_by_type_graph
    start,last=translate(params[:id])
    data=ItCase.summary_average_workon_by_type(start,last)
    g=Graph.new(data)
    img=g.bar("按类别工单处理时间")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "workon_type.png")
  end

  def workon_by_staff_graph
    start,last=translate(params[:id])
    data=Task.summary_average_workon_by_staff(start,last)
    g=Graph.new(data)
    img=g.bar("人员平均处理工单时间")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "workon_staff.png")
  end

  def rank_graph
    start,last=translate(params[:id])
    data=ItCase.summary_by_rank(start,last)
    g=Graph.new(data)
    img=g.pie("评分分布图")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "rank.png")
  end

  def rank_by_staff_graph
    start,last=translate(params[:id])
    data=ItCase.summary_rank_by_staff(start,last)
    g=Graph.new(data)
    img=g.bar("人员评分图")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "rank_staff.png")
  end

  def callin_graph
    start,last=translate(params[:id])
    data=ItCase.summary_callin_type(start,last)
    g=Graph.new(data)
    img=g.pie("工单渠道分类")
    send_data( img.to_blob,:disposition => 'inline',
               :type => 'image/png',
               :filename => "callin.png")
  end
  private
  def translate(id)
    start_year=id[0..3]
    start_month=id[4..5]
    start_day=id[6..7]
    end_year=id[8..11]
    end_month=id[12..13]
    end_day=id[14..15]
    [Time.local(start_year,start_month,start_day),Time.local(end_year,end_month,end_day,23,59) ]


  end
end
