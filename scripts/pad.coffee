module.exports = (robot) ->
  robot.hear /pad (\d+)/i, (res) ->
    sqlite3 = require('sqlite3').verbose()
    db = new sqlite3.Database('./pad.sqlite')
    db.serialize () ->
      db.each "select * from monsters where pad_id=" + res.match[1], (err, row) ->
        str = "No.#{row.pad_id} #{row.name} (#{row.c_name})\n屬性: #{row.element}"
        if row.sub_element
          str += "/#{row.sub_element}"
        str += "\nType: #{row.type}"
        if row.sub_type
          str += "/#{row.sub_type}"
        str += "\n滿等需要經驗值: #{row.need_exp}\n"
        str += "滿等時HP: #{row.hp} 攻擊: #{row.atk} 回復: #{row.rcv}\n"
        str += "主動技: #{row.skill_name} (#{row.skill_cd} -> #{row.skill_min_cd})\n"

        skills = row.skill.split("\n")
        for skill in skills
          str += "> #{skill}\n"
  
        str += "隊長技: #{row.lskill_name}\n"

        lskills = row.lskill.split("\n")
        for lskill in lskills
          str += "> #{lskill}\n"

        res.send "https://dl.dropboxusercontent.com/u/78642/pad/pet_icons/#{res.match[1]}.png"
        res.send str
    db.close()
