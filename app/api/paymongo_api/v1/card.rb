module PaymongoApi
    module V1
        class Card
            include ApiExceptions
            Base_url = "https://api.paymongo.com/v1"
            Payment_methods = "/payment_methods"
            Payment_intents = "/payment_intents"
            Token = Rails.application.credentials.Token

            def create_payment_intent
                response = connection.post("#{Payment_intents}") do | request |
                    request.body = {

                        data: {
                            attributes: {
                                amount: 100000.to_i, 
                                payment_method_allowed: ['card', 'paymaya'], 
                                payment_method_options: {
                                    card: {
                                    request_three_d_secure: 'any', 
                                    }
                                }, 
                                currency: 'PHP'
                            }
                        }

                    }.to_json
                end
                JSON.parse(response.body, object_class: OpenStruct)
            end

            def create_payment_method(card, billing, type)

                response = connection.post("#{Payment_methods}") do | request |
                    request.body = {
                        data: {
                            attributes:{
                                details:{ 
                                    card_number: card[:card_number],
                                    exp_month: card[:exp_month],
                                    exp_year: card[:exp_year],
                                    cvc: card[:cvc],
                                },
                                billing:{
                                    address:{
                                        line1: billing[:address][:line1],
                                        city: billing[:address][:city],
                                        state: billing[:address][:state],
                                        postal_code: billing[:address][:postal_code],
                                        country: billing[:address][:country],
                                    },
                                    name:billing[:name],
                                    email:billing[:email],
                                    phone:billing[:phone]
                                },
                                type:type,

                            }
                        }

                    }.to_json

                end
                @method_body = JSON.parse(response.body, object_class: OpenStruct)
            end

            def attach(payment_intent_id, payment_method_id, client_key)
                
                
                response = connection.post("#{Payment_intents}/#{payment_intent_id}/attach")  do | request |

                    request.body = {

                        data: {
                            attributes: {
                            payment_method: payment_method_id, 
                            client_key: client_key,
                            return_url: "https://huntr-clone.herokuapp.com/subscription/card/success"
                            }
                        }

                    }.to_json
                end
                
                @data = JSON.parse(response.body, object_class: OpenStruct)
            
            end

            def attach_id
                data =  @data.data.id
                id = data.to_s
            end

            def payment_type?
                data =  @method_body.data.attributes.type
                type = data.to_s
                
            end

            def redirect_url
                data =  @data.data.attributes.next_action.redirect.url
                url = data.to_s
            end

            def retrieve_payment_intent(id)
                
                response = connection.get("#{Payment_intents}/#{id}") 
                JSON.parse(response.body, object_class: OpenStruct)
            end

            def subscription_status?
                data =  @data.data.attributes.payments[0].attributes.status
                status = data.to_s
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