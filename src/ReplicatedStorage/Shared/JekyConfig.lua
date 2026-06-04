local JekyConfig = {}
JekyConfig.RoleRules = {
    Owner     = { UserIds = {}, Usernames = { 'adamzz3372' } },
    Developer = { UserIds = {}, Usernames = { '' } },
    HeadAdmin = { UserIds = {}, Usernames = { '' } },
    Admin     = { UserIds = {}, Usernames = { '' } },
    Moderator = { UserIds = {}, Usernames = { '' } },
    Streamer  = { UserIds = {}, Usernames = { '' } },
    Community = { UserIds = {}, Usernames = { '' } },
}
JekyConfig.RoleOrder = { 'Owner','Developer','HeadAdmin','Admin','Moderator','Streamer','Community' }
JekyConfig.RoleDisplay = {
    Owner='👑OWNER', Developer='DEVELOPER', HeadAdmin='HEAD ADMIN',
    Admin='ADMIN', Moderator='MODERATOR', Streamer='STREAMER', Community='COMMUNITY',
}
JekyConfig.RoleColors = {
    Owner=Color3.fromRGB(255,215,0), Developer=Color3.fromRGB(0,255,255),
    HeadAdmin=Color3.fromRGB(148,0,211), Admin=Color3.fromRGB(255,69,0),
    Moderator=Color3.fromRGB(50,205,50), Streamer=Color3.fromRGB(255,0,0),
    Community=Color3.fromRGB(255,182,193),
}
JekyConfig.RoleUsesGradient = { Owner=true, Community=true }
JekyConfig.AdminRoles = { Owner = true, Developer = true, HeadAdmin = true, Admin = true }
JekyConfig.SUMMIT_REWARDS = { Summit = 1, ApexSummit = 2 }
return JekyConfig