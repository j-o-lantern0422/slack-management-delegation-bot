require_relative './invite.rb'
class Command
  def invite(call)
    command_line = call.split(" ")
    raise if command_line.first == "invite"
    return invite_help if command_line.size < 2 || command_line[2] == "help"

    mail = parce_mail(command_line[2])
    name = command_line[3]

    return "invalid mail address" if valid_mail_address?(mail).!

    Invite.new.invite(mail: mail, name: name)
  end

  private
    def invite_help
      <<-"EOS"
      invite command help
      @bot invite : view this help
      @bot invite hoge@mail.com : invite mail send
      @bot invite hoge@mail.com hoge : invite mail send and user name set "hoge"
      EOS
    end

    def valid_mail_address?(mail_address)
      valid_address = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/
      (valid_address =~ mail_address).nil?.!
    end

    # when post mail address, it will change to mail link
    def parce_mail(mail)
      if mail.include?("<mailto:")
        mail.slice!("<mailto:")
        return mail.sub!(/\|.*/m, "")
      end

      mail
    end
end

