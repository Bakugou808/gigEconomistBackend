class User < ApplicationRecord
    has_many :clients
    has_many :services 
    has_secure_password

    def self.totalCurrVsProj(userId)
        user = User.find(userId) 
        services = user.services 
        appointments = []
        services.each{|service| 
            service.gigs.each{|gig| appointments << gig.appointments }
        } 
        appointments.flatten!
        
        data = {}

        appointments.each{|appointment| 
            year = appointment.date_of_appointment.strftime('%Y')
            month = appointment.date_of_appointment.strftime('%B')
            payment = appointment.payment_amount.split("$")[1].to_i
            if data[year]
                if data[year][:monthly][month] 
                    if appointment.completed
                        data[year][:totals][:totalCurr] += payment 
                        data[year][:monthly][month][:curr] += payment 
                        data[year][:monthly][month][:compAppts] += 1
                        data[year][:totals][:compAppts] += 1
                    end
    
                    data[year][:totals][:totalProj] += payment 
                    data[year][:monthly][month][:proj] += payment 
                    data[year][:monthly][month][:apptCount] += 1
                    data[year][:totals][:totalAppts] += 1 
                
                else 
                    data[year][:monthly][month] = {proj: 0, curr: 0, apptCount: 0, compAppts: 0}

                    if appointment.completed
                        data[year][:totals][:totalCurr] += payment 
                        data[year][:monthly][month][:curr] += payment 
                        data[year][:monthly][month][:compAppts] += 1
                        data[year][:totals][:compAppts] += 1
                    end

                    data[year][:totals][:totalProj] += payment 
                    data[year][:monthly][month][:proj] += payment 
                    data[year][:monthly][month][:apptCount] += 1
                    data[year][:totals][:totalAppts] += 1
                    
                    end
                
            else 
                data[year] = {totals: {totalCurr: 0, totalProj: 0, totalAppts: 0, compAppts: 0}, monthly: {}}
                data[year][:monthly][month] = {proj: 0, curr: 0, apptCount: 0, compAppts: 0}

                if appointment.completed
                    data[year][:totals][:totalCurr] += payment 
                    data[year][:monthly][month][:curr] += payment 
                    data[year][:monthly][month][:compAppts] += 1
                    data[year][:totals][:compAppts] += 1
                end

                data[year][:totals][:totalProj] += payment 
                data[year][:monthly][month][:proj] += payment 
                data[year][:monthly][month][:apptCount] += 1
                data[year][:totals][:totalAppts] += 1
            end
        }
     
        # data = {projected: 0, current: 0}

        # appointments.each{|appointment| 
        #     if appointment.completed
        #         data[:current] += appointment.payment_amount.split("$")[1].to_i
        #     end 
        #     data[:projected] += appointment.payment_amount.split("$")[1].to_i
        # }

        

        data 
    end

end
