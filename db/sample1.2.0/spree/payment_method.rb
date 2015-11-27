payment_method = Spree::PaymentMethod.where(:name => 'Alipay', :active => true).first
payment_method.preferred_email = 'areq22@aliyun.com'
payment_method.preferred_alipay_pid = '2088002627298374'
payment_method.preferred_alipay_key = 'f4y25qc539qakg734vn2jpqq6gmybxoz'
payment_method.save!
