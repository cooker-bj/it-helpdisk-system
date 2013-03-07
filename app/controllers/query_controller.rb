#-*- encoding: UTF-8 --*-
class QueryController < ApplicationController
  before_filter :login_required,:has_right?

  def index
    @start=(Time.now-1.days)
    @last=(Time.now)
  end

  def query
    @start=Time.local(params[:start][:year],params[:start][:month],params[:start][:day])
    @last=Time.local(params[:end][:year],params[:end][:month],params[:end][:day],24 )
    casetype=params[:casetype]
    rank=params[:rank]
    comment=params[:comment]
    email=params[:staff_email]
    @itcases=ItCase.where("opened_time>:start and opened_time<:last",:start=>@start,:last=>@last)
    @itcases=@itcases.where(:casetype=>casetype) unless casetype.empty?
    @itcases=@itcases.where(:rank=>rank) unless rank.empty?
    @itcases=case
               when comment.empty? then @itcases
               when comment=="已评价"  then @itcases.where("comment is not null")
               when comment=="未评价"  then @itcases.where("comment is null")
             end
    unless email.empty?
      userid=User.find_by_mail(email).id
      @itcases=@itcases.joins(:tasks).where("tasks.userid=:id",:id=>userid)
    end


  end
end
