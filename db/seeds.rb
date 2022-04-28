
User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password" ,
             admin:true)
             
             
User.create!(name: "上司A",
             email: "sampleA@email.com",
             password: "password",
             password_confirmation: "password" ,
             superior:true)
             
User.create!(name: "上司B",
             email: "sampleB@email.com",
             password: "password",
             password_confirmation: "password" ,
             superior:true)
             
User.create!(name: "一般ユーザー1",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password" )
             
             
User.create!(name: "一般ユーザー２",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password" )
             
User.create!(name: "一般ユーザー3",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password" )
             

puts "Users Created"