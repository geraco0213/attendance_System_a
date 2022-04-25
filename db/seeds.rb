User.create!(name: "Sample User",
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
             
             
User.create!(name: "一般ユーザー１",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password" ,
             )





puts "Users Created"