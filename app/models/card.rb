class Card
  include Mongoid::Document
  include Mongoid::Timestamps  
  PAY_STATUS_PAYING     = 1 #等待付款
  PAY_STATUS_PAYED      = 2 #已付款

  PAY_STATUS_HASH = {1 => '等待付款',2 => '已付款'}

  CARD_TYPE_1      = 1 #订单
  CARD_TYPE_2      = 2 #冲销单
  TYPE_HASH        = {1 => '订单', 2 => '冲销单'}

  EXEC_STATUS_0    = 0 #等待执行
  EXEC_STATUS_1    = 1 #执行中
  EXEC_STATUS_2    = 2 #执行完毕
  EXEC_STATUS_HASH = {0 => '等待执行',1 => '执行中',2 => '执行完毕'}

  field :serial_number, type: String #学习卡编号
  field :type, type: Integer,default:CARD_TYPE_1 # 订单、冲销单
  field :status_payment,type: Integer,default:PAY_STATUS_PAYING #等待付款已付款
  field :status_execution,type: Integer,default:EXEC_STATUS_0 #执行状态
  field :quantity_purchased,type:Integer,default:0 #购买的人天数
  field :quantity_used,type: Integer,default:0 #已使用人天数
  field :amount_payable,type: Integer,default:0 #应付金额人民币
  field :amount_paid,type: Integer,default:0 #实付金额人民币
  field :date_paid,type: Date # 付款日期
  field :buyer_voucher,type: String #买方付款凭证号
  field :receipt_num,type: String #发票号
  field :buyer,type: String #买方联系人
  field :buyer_mobile,type: String #买方联系人电话
  field :post_address,type: String # 发票邮寄地址
  field :finished_at,type: Date #执行完毕日期

  belongs_to :company, class_name: "Company", inverse_of: :card

  
  def self.create_new(opt)
    c = Company.where(id:opt[:company_id]).first
    if c.present?
      self.create(opt)
    end
    
    return true
  end

  def self.search(opt)    
    result = self.all
    if opt['company'].present? 
      company = Company.where(name: /#{opt['company']}/).first
      result = company.cards
    end
    if opt['serial'].present?    
      result = result.where(serial_number: /#{opt['serial']}/)
    end
    if opt['receipt'].present?    
      result = result.where(receipt_num: /#{opt['receipt']}/)
    end     
    if opt['buyer'].present?    
      result = result.where(buyer: /#{opt['buyer']}/)
    end 
    if opt['mobile'].present?    
      result = result.where(buyer_mobile: /#{opt['mobile']}/)
    end 
    if opt['status'].present?    
      result = result.where(status_payment: opt['status'].to_i)
    end 
    if opt['type'].present?    
      result = result.where(type: opt['type'].to_i)
    end 
    if opt['exec'].present?    
      result = result.where(status_execution: opt['exec'].to_i)
    end
    return result    
  end

  def self.update_info(opt,inst)
    c = Company.where(id:opt[:company_id]).first
    if c.present?
      inst.update(opt)
    end
    return true
  end

  def self.check_serial(opt)
    card = Card.where(serial_number:opt[:num]).first
  end


end
