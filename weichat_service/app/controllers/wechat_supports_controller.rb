require 'digest/sha1'
class WechatSupportsController < ApplicationController
  def index
  end

  #----------------------------------接入校验部分——————————————————————————————————————
  @@token="marvenhool"

  def auth_wechat
    if check_signature?(params[:signature],params[:timestamp],params[:nonce])
    return render text: params[:echostr]
    else
    return render text: "signature check faild!"
    end
  end

  #----------------------------------接入校验部分——————————————————————————————————————

  #微信开发者验证
  #申请微信开发者将自己的服务器地址，微信服务器会发送一个GET请求给你的服务器，
  #根据收到的GET请求参数，根据自己的taken信息进行SHA1排序，并且与signature比对校验
  #如果成功则表示该GET请求来自于微信服务器，并返回随机字符串（也是微信发送过来的）
  #这样就验证通过
  #---------------------------------校验部分结束------------------------------------

  #接收微信服务器信息
  def process_request
    if check_signature?(params[:signature], params[:timestamp], params[:nonce]) #验证消息真实性
      if params[:xml][:MsgType] == "event"
        if params[:xml][:Event] == "subscribe"
          render xml:"wechat_supports/info"  #, layout: false, :formats => :xml #关注
        end
      else
          render xml:"wechat_supports/info" #其他条件下，也暂时回复相同内容
      end
    end
  end

  #-------------------------------Private method-----------------------------------

  private
  def check_signature?(signature,timestamp,nonce)
    Digest::SHA1.hexdigest([timestamp,nonce,@@token].sort.join) == signature
  end

end