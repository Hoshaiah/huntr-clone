module PaymongoApi
    module V1
        class EwalletGcash
            include ApiExceptions
            Base_url = "https://api.paymongo.com/v1"
            Source = "/sources"
            Payments = "/payments"
            Token = Base64.encode64(Rails.application.credentials.dig(:paymongo, :secret_key))

            def create_source_gcash

                response = connection.post("#{Source}") do | request |
                    request.body = {
                        
                        data:{
                            attributes:{
                                amount:100000.to_i,
                                redirect:{
                                    success:"http://127.0.0.1:3000/payments/gcash/success",
                                    failed:"http://127.0.0.1:3000/subscription/ewallet/failed"
                                },
                                type:"gcash",
                                 currency:"PHP"
                            }
                        }

                    }.to_json
                end
                JSON.parse(response.body, object_class: OpenStruct)
            end

            def gcash_create_payments

                id = create_source_gcash.data.id.to_s

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

            def gcash_status?
                status = create_source_gcash.data.attributes.status.to_s
            end

            def gcash_checkout_url
                url = create_source_gcash.data.attributes.redirect.checkout_url.to_s
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

