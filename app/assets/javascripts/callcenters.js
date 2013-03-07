/**
 * Created with JetBrains RubyMine.
 * User: kang.cao
 * Date: 12-7-25
 * Time: 下午12:16
 * To change this template use File | Settings | File Templates.
 */


$(function(){
        $("#email").change(function(){$.post("/callcenters/get_user",{"email":$('#email').val()},function(data){
        $("#name").attr('value',data.name);
            $("#department").attr('value',data.department);
        })})}

);
