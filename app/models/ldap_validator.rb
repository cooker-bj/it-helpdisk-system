#--*- encoding: UTF-8
class LdapValidator<ActiveModel::Validator
  def validate(record)
    user_field=options[:attr]
    record.errors[:base]<<"不存在的用户" unless User.find_by_name(record.send(user_field))
  end
  # To change this template use File | Settings | File Templates.
end