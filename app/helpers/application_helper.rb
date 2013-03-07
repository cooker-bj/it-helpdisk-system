module ApplicationHelper
  def location_help
    mylocation=case (request.remote_ip)
                 when  /10\.2\.(\d\.|[1-5]\d\.|6[0-3]\.)(\d{1,2}$|1\d{2}$|2[0-4]\d$|25[0-4]$)/   then ItCase::LOCATIONS[1]
                 when /10\.2\.(6[4-9]\.|[7-9]\d\.|1[0,1]\d\.|12[0-7]\.)(\d{1,2}$|1\d{2}$|2[0-4]\d$|25[0-4]$)/ then ItCase::LOCATIONS[0]
                 when /10\.2\.1(2[8,9]\.|[3-8]\d\.|9[0,1]\.)(\d{1,2}$|1\d{2}$|2[0-4]\d$|25[0-4]$)/ then  ItCase::LOCATIONS[2]
 		 when /10\.5\.4\.\d/ then ItCase::LOCATIONS[3]
                 when /10\.2\.(19[0-2]\.|2[0-4]\d\.|25[0-5]\.)(\d{1,2}$|1\d{2}$|2[0-4]\d$|25[0-4]$)/ then ItCase::LOCATIONS[4]
                 else
                   ItCase::LOCATIONS[5]
               end
    mylocation
    end


end
