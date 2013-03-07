class Graph

  def initialize(data)
    @data=data
    @font="/usr/share/fonts/chinese/TrueType/uming.ttf"

  end


  def oneline(title)
    g=Gruff::Line.new
    g.title=title
    labels=Hash.new
    g.font=@font
    mydata=[]
    unless @data.nil?
      i=0
      @data.each do |key,value|
        labels[i]=key
        mydata<<value
        i+=1
      end
    end
    g.labels=labels
    g.data(title,mydata)
    g
  end

  def bar(title)
    g=Gruff::Bar.new
    g.title=title
    g.font=@font
    labels=Hash.new
    mydata=[]

    unless @data.nil?
      i=0
      @data.each do |key,value|
        labels[i]=key
        mydata<<value

        i+=1
      end

    end
    g.labels=labels
    g.data(title,mydata)

    g

  end

 def twobar(title,l1,l2)
   g=Gruff::Bar.new
   g.title=title
   g.font=@font
   labels=Hash.new
   data1=[]
   data2=[]
   unless @data.nil?&&@data[l1].nil?&&data[l2].nil?
     i=0
     @data[l1].each do |key,value|
       labels[i]=key
       data1<<f_value(value)
       data2<<f_value(@data[l2][key])
       i+=1
     end

   end
   g.labels=labels
   g.data(l1,data1)
   g.data(l2,data2)
   g

 end

  def pie(title)
    g=Gruff::Pie.new
    g.title=title
    g.font=@font
    unless @data.nil?
      @data.each do |key,value|
        key=key.nil? ? 'nil' : key
        g.data(key,value)
      end
    end
    g
  end

private
  def  f_value(value)
    case
     when  value.nil? then 0
  else
    value

  end
  end



end
