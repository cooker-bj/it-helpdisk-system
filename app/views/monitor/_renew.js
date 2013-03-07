$(function(){
        setInterval(function(){
            $.get("/monitor",function(data){
                $("#cases").html(data.cases);
                $("#closed").html(data.closed);
                $("#waiting").html(data.waiting);
                $("#waiting_more_than_hours").html(data.waiting_more_than_hours);
                $("#working").html(data.working);
                $("#working_cases_more_than_one_day").html(data.working_cases_more_than_one_day) ;
            },'json')
        },6000)
    }

);
