require 'spreadsheet'
class Admin::OrdersController < Admin::AdminController
  before_action :refuse_viewer, only: [:check_order,:make_attend,:cancel_order]

  def index
    if request.xhr?
      search
      render :partial => 'admin/orders/index.js.erb', :locals => { :orders => @orders }
    else
      search
      respond_to do |format|  
        format.xls {   
          send_data(xls_content_for(@orders), :type => "text/excel;charset=utf-8; header=present", :filename => "Report#{Time.now.strftime("%Y%m%d")}.xls")  
        }
        format.html          
      end
    end
  end

  def search
    params[:t] ||= 'o'
    @orders = auto_paginate(Order.admin_search(params))
  end

  #系统管理员审核报名
  def check_order
    render_json_auto Order.check_order(params)
  end

  #系统管理员标示已结束课程报名表的出席情况
  def make_attend
    render_json_auto Order.make_attend(params)
  end

  def cancel_order
    render_json_auto Order.admin_cancel(params)
  end

  def generate_proxy_order
    render_json_auto Order.generate_proxy_order(params)
  end

  private
  def xls_content_for(obj)
    obj = obj['data']
    xls_report = StringIO.new  
    book = Spreadsheet::Workbook.new  
    sheet1 = book.create_worksheet :name => "报名表"  
      
    blue = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 10,:horizontal_align => :center 
    sheet1.row(0).default_format = blue  
    sheet1.merge_cells(0, 0, 0, 4)
    sheet1[0,0] = obj[0].course.try(:name_en) || '课程名称'
    sheet1.row(1).concat %w{公司名称 报名人  邮箱  手机号 报名日期    }  
    count_row = 2  
    obj.each do |obj|  
      sheet1[count_row,0]=  obj.user.company.name  
      sheet1[count_row,1]=  obj.user.name
      sheet1[count_row,2]=  obj.user.email
      sheet1[count_row,3]=  obj.user.mobile
      sheet1[count_row,4]=  obj.created_at.strftime('%F')  
      count_row += 1  
    end
    book.write xls_report  
    xls_report.string      
  end

end
