class Service < ApplicationRecord
  belongs_to :user
  has_many :gigs, dependent: :destroy

  def self.monthsGigs(serviceId)
    service = Service.find(serviceId)
    gigs = service.gigs 
    start_date = Time.now.beginning_of_month.to_date
    end_date = Time.now.end_of_month.to_date
    # x = gigs[0].appointments.group_by{|appt| appt.created_at.month}
    
    gigHash = {}
    gigs.each{|gig| gigHash[gig.title] =  (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))}

    gigHash
  end  

  def self.earnedVsProjected(serviceId)
    service = Service.find(serviceId)
    gigs = service.gigs 
    start_date = Time.now.beginning_of_month.to_date
    end_date = Time.now.end_of_month.to_date
    appts = []
    earned = {sum: 0, appointments: []}
  
    projected = {sum: 0, appointments: []}


    gigs.each{|gig| 
      appts << (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
}


    appts.flatten.each{|appt| 
      
      if appt[:completed] 
        earned[:appointments] << appt
        earned[:sum] += appt[:payment_amount].split('$')[1].to_i
      end 
      projected[:appointments] << appt 
      projected[:sum] += appt[:payment_amount].split('$')[1].to_i
    }
    
    earnedVsProjected = {earned: earned, projected: projected}
    
  end

  def self.mostLuc(user_id)

    user = User.find(user_id)
    services = user.services 
    gigs = services.map{|service| service.gigs.map{|gig| gig }}
    gigs.flatten!
    start_date = Time.now.beginning_of_month.to_date
    end_date = Time.now.end_of_month.to_date

    serviceHash = {}
    gigs.each{|gig| 
      if serviceHash[gig.service_type]
        appts = (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
        appts.each{|appt| 
          if appt.completed
            serviceHash[gig.service_type][:sum] += appt.payment_amount.split('$')[1].to_i
            serviceHash[gig.service_type][:complete] += 1
          end
          serviceHash[gig.service_type][:projSum] += appt.payment_amount.split('$')[1].to_i
          serviceHash[gig.service_type][:apptCount] += 1
        }


      else 
        serviceHash[gig.service_type] = {sum: 0, complete:0, apptCount: 0, projSum: 0, incomplete: 0}
        appts = (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
        appts.each{|appt| 
          if appt.completed
            serviceHash[gig.service_type][:sum] += appt.payment_amount.split('$')[1].to_i
            serviceHash[gig.service_type][:complete] += 1
          end
          serviceHash[gig.service_type][:projSum] += appt.payment_amount.split('$')[1].to_i
          serviceHash[gig.service_type][:apptCount] += 1
        }
      end
      serviceHash[gig.service_type][:incomplete] = (serviceHash[gig.service_type][:apptCount] - serviceHash[gig.service_type][:complete])
    }

    
    serviceHash


  end

  def self.thisWeek(user_id)
    user = User.find(user_id)
    services = user.services 
    gigs = services.map{|service| service.gigs.map{|gig| gig }}
    gigs.flatten! 

    start_date = Time.now.beginning_of_month.to_date
    end_date = Time.now.end_of_month.to_date
    appts = {"Sunday": [], "Monday": [], "Tuesday": [], "Wednesday": [], "Thursday": [], "Friday": [], "Saturday": []}
    apptArr = []
    gigs.each{|gig| 
      apptArr <<  (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))}
    
    apptArr.flatten!
    apptArr.each{|appt| 
      day = appt.date_of_appointment.strftime("%A")
      
        appts[day.to_sym] << appt 
    
    }
    appts
    
  end

  def self.mostPop(user_id)
    user = User.find(user_id)
    services = user.services 
    gigs = services.map{|service| service.gigs.map{|gig| gig }}
    gigs.flatten!
    start_date = Time.now.beginning_of_month.to_date
    end_date = Time.now.end_of_month.to_date

    serviceHash = {}
    gigs.each{|gig| 
      if serviceHash[gig.service_type]
        serviceHash[gig.service_type] <<  (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
        serviceHash[gig.service_type].flatten!
      else 
        serviceHash[gig.service_type] = []
        serviceHash[gig.service_type] <<  (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
        serviceHash[gig.service_type].flatten!

      end
    }

    # ordered = serviceHash.sort_by{|service, array| -array.length}
    
    serviceHash

  end

  def self.totalStats(user_id)
    user = User.find(user_id)
    start_date = Time.now.beginning_of_year.to_date
    end_date = Time.now.end_of_year.to_date
    services = Service.where(['created_at > ? AND created_at < ? AND user_id = ?', start_date, end_date, user.id])
    appointments = {totals: {totalSum: 0, projSum: 0, totalAppts: 0, totalServices: 0, completed: 0, incomplete: 0}, services: {}}
    
    services.each{|service| 
      service.gigs.each{|gig|
        gig.appointments.each{|appt| 
          
          if !appointments[:services][service.title]
            appointments[:services][service.title] = {completed: 0, incomplete: 0, count: 0, totalSum: 0, projSum: 0}
          end 
          
          if appt.completed 
            appointments[:services][service.title][:completed] += 1
            appointments[:totals][:completed] += 1 
            appointments[:services][service.title][:totalSum] += appt.payment_amount.split('$')[1].to_i 
            appointments[:totals][:totalSum] += appt.payment_amount.split('$')[1].to_i
          else 
            appointments[:totals][:incomplete] += 1 
            appointments[:services][service.title][:incomplete] += 1
          end 
          appointments[:services][service.title][:count] += 1
          appointments[:totals][:totalAppts] += 1 
          appointments[:services][service.title][:projSum] += appt.payment_amount.split('$')[1].to_i 
          appointments[:totals][:projSum] += appt.payment_amount.split('$')[1].to_i
        } 
      }
      appointments[:totals][:totalServices] += 1
    }
        
    appointments

  end 

  def self.mostTime(user_id)
    user = User.find(user_id)
    services = user.services 
    gigs = services.map{|service| service.gigs.map{|gig| gig }}
    gigs.flatten!
    start_date = Time.now.beginning_of_month.to_date
    end_date = Time.now.end_of_month.to_date

    serviceHash = {}
    gigs.each{|gig| 
      if serviceHash[gig.service_type]
        appts = (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
        appts.each{|appt| 
          if appt.completed
            serviceHash[gig.service_type][:sum] += appt.payment_amount.split('$')[1].to_i
            serviceHash[gig.service_type][:apptCount] += 1
            serviceHash[gig.service_type][:totalTimeMin] += (appt.end_of_appointment - appt.time_of_appointment)
            
          end
        }
      else 
        serviceHash[gig.service_type] = {sum: 0, totalTimeMin: 0, apptCount: 0}
        appts = (Appointment.where(['date_of_appointment > ? AND date_of_appointment < ? AND gig_id = ?', start_date, end_date, gig.id]))
        appts.each{|appt| 
          if appt.completed
            serviceHash[gig.service_type][:sum] += appt.payment_amount.split('$')[1].to_i
            serviceHash[gig.service_type][:apptCount] += 1
            serviceHash[gig.service_type][:totalTimeMin] += (appt.end_of_appointment - appt.time_of_appointment)
          end
        }
      end
    }
    
    serviceHash
  end


end
