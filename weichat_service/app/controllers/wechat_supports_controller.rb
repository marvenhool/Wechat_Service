require 'digest/sha1'
class WechatSupportsController < ApplicationController
  def index
  end

  #----------------------------------校验部分——————————————————————————————————————
  @@token="marvenhool"

  def auth_wechat
    if check_signature?(params[:signature],params[:timestamp],params[:nonce])
    return render text: params[:echostr]
    else
    return render text: "signature check faild!"
    end
  end

  private
  def check_signature?(signature,timestamp,nonce)
    Digest::SHA1.hexdigest([timestamp,nonce,@@token].sort.join) == signature
  end
  #----------------------------------校验部分——————————————————————————————————————

  #微信开发者验证
  #申请微信开发者将自己的服务器地址，微信服务器会发送一个GET请求给你的服务器，
  #根据收到的GET请求参数，根据自己的taken信息进行SHA1排序，并且与signature比对校验
  #如果成功则表示该GET请求来自于微信服务器，并返回随机字符串（也是微信发送过来的）
  #这样就验证通过
  #---------------------------------校验部分结束------------------------------------
end