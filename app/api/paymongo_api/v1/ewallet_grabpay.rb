module PaymongoApi
    module V1
        class EwalletGrabpay
            include ApiExceptions
            Base_url = "https://api.paymongo.com/v1"
            Source = "/sources"
            Payments = "/payments"
            Token = Rails.application.credentials.Token

            def create_source_grabpay
                response = connection.post("#{Source}") do | request |
                    request.body = {

                        
                        data:{
                            attributes:{
                                amount:100000.to_i,
                                redirect:{
                                    success:"http://localhost:3000//payments/grabpay/success",
                                    failed:"http://localhost:3000/subscription/ewallet/failed"
                                },
                                type:"grab_pay",
                                 currency:"PHP"
                            }
                        }
                        
                    }.to_json
                end
                JSON.parse(response.body, object_class: OpenStruct)
            end

            def grabpay_create_payments

                id = create_source_grabpay.data.id.to_s

                response = connection.post("#{Payments}") do | request |
                    request.body = {

                        data:{
                            attributes:{
                                amount:100000.to_i,
                                source:{
                                    id: id,
                                    type:"source"
                                },
                                currency:"PHP"
                            }
                        }

                    }.to_json
                end
                JSON.parse(response.body, object_class: OpenStruct)
            end

            def grabpay_status?
                status = create_source_grabpay.data.attributes.status.to_s
            end

            def grabpay_checkout_url
                url = create_source_grabpay.data.attributes.redirect.checkout_url.to_s
            end
   
            private 

            def connection
                @connection ||= Faraday.new(
                    url: Base_url,
                    headers: {
                        "Content-Type" => "application/json",
                        "Authorization" => "Basic #{Token}" 
                    },
                )
            end
        end

    end
end

