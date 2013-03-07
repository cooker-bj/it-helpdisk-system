require 'ldap'

class User
  attr_accessor :id,:name,:department,:email,:salt
  @@host=TaskTracingSystem::Application.config.ldap_conf['host']
  @@port=TaskTracingSystem::Application.config.ldap_conf['port']
  @@dn=TaskTracingSystem::Application.config.ldap_conf['dn']



  def initialize(uid,name,department,email,salt)
    @id=uid
    @name=name
    @department=department
    @email=email
    @salt=salt
  end


  def self.authenticate(login,password)
    begin
      conn=build_conn

      conn.bind(login,password)
      ActiveRecord::Base.logger.info "conn bound"
      user= login_search(conn,login)

    rescue => e
      ActiveRecord::Base.logger.info "authenticated error:authenticate #{e}"
      user= nil
    ensure
      conn.unbind unless conn.nil?
      user
    end

  end


  def self.authenticate_with_salt(id,salt)
    user=find_by_id(id)
    (user&&user.salt==salt)?user: nil

  end



  def self.build_conn
    conn=LDAP::Conn.new(@@host,@@port)
    conn.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3)
    conn.set_option(LDAP::LDAP_OPT_REFERRALS, 0)
    conn
  end



  def self.build_bind_conn
    conn=build_conn
    conn.bind(TaskTracingSystem::Application.config.ldap_conf['username'],TaskTracingSystem::Application.config.ldap_conf['password'])
    conn

  end

  def self.find_by_id(id)


      return bound_search("uSNCreated",id).first



  end

  def self.find_by_name(name)


      return bound_search("displayName",name).first

  end

  def self.find_by_mail(email)


      return bound_search("mail",email).first

  end


  def self.find_users_by_department(dep)
    return bound_search("department",dep)
  end
  private

  def self.search(conn,mykey,myvalue)
     li=[]
    result=conn.search2(@@dn,LDAP::LDAP_SCOPE_SUBTREE,"#{mykey}=#{myvalue}",['uSNCreated','displayName','department','mail','msExchMailboxGuid'])
     result.each do |item|
     li<< User.new(get_value(item['uSNCreated']),get_value(item['displayName']),get_value(item['department']),get_value(item['mail']),get_value(item['msExchMailboxGuid']))
     end
    li
  end

   def self.login_search(conn,myvalue)
      result=conn.search2(@@dn,LDAP::LDAP_SCOPE_SUBTREE,"(|(mail=#{myvalue})(userPrincipalName=#{myvalue}))",['uSNCreated','displayName','department','mail','msExchMailboxGuid'])
      return User.new(get_value(result.first['uSNCreated']),get_value(result.first['displayName']),get_value(result.first['department']),get_value(result.first['mail']),get_value(result.first['msExchMailboxGuid']))

   end

  def self.bound_search(mykey,myvalue)
  bound_conn=build_conn
  result=nil
  begin
  bound_conn.bind(TaskTracingSystem::Application.config.ldap_conf['username'],TaskTracingSystem::Application.config.ldap_conf['password'])  do |myconn|
    result=search(myconn,mykey,myvalue)
  end
  rescue =>e
    ActiveRecord::Base.logger.info "bound_search error: #{e} :error_end"
    result=[]
    end
     result
  end

  def self.mutl_search(conn,mykey,myvalue)
    result=nil
   mysets=conn.search2(@@dn,LDAP::LDAP_SCOPE_SUBTREE,"(|(mail=#{myvalue})(userPrincipalName=#{myvalue}))",['uSNCreated','displayName','department','mail','msExchMailboxGuid'])
    mysets&& mysets.each {|myset|}
  end

  def self.get_value(v)
    v.first.force_encoding("UTF-8")
  end
end
