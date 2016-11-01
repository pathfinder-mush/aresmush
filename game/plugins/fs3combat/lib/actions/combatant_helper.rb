module AresMUSH
  module FS3Combat
    
    def self.roll_attack(combatant, mod = 0)
      ability = FS3Combat.weapon_stat(combatant.weapon, "skill")
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      aiming_mod = (combatant.is_aiming? && (combatant.aim_target == combatant.action.target)) ? 3 : 0
      luck_mod = (combatant.luck == "Attack") ? 3 : 0
      mod = mod + accuracy_mod - damage_mod + stance_mod + aiming_mod + luck_mod - stress_mod
      
      Global.logger.debug "Attack roll for #{combatant.name} ability=#{ability} aiming=#{aiming_mod} mod=#{mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} luck=#{luck_mod} stress=#{stress_mod}"
      
      combatant.roll_ability(ability, mod)
    end
    
    def self.roll_defense(combatant, attacker_weapon)
      ability = FS3Combat.weapon_defense_skill(combatant, attacker_weapon)
      stance_mod = combatant.defense_stance_mod
      luck_mod = (combatant.luck == "Defense") ? 3 : 0
      mod = stance_mod + luck_mod - combatant.total_damage_mod
      
      Global.logger.debug "Defense roll for #{combatant.name} ability=#{ability} stance=#{stance_mod} luck=#{luck_mod}"
      
      combatant.roll_ability(ability, mod)
    end
    
    # Attacker           |  Defender            |  Skill
    # -------------------|----------------------|----------------------------
    # Any weapon         |  Pilot type          |  Pilot's vehicle skill
    # Any weapon         |  Passenger type      |  Pilot's vehicle skill
    # Melee weapon       |  Melee weapon        |  Defender's weapon skill
    # Melee weapon       |  Other weapon        |  Default combatant type skill
    # Other weapon       |  Other weapon        |  Default combatant type skill
    def self.weapon_defense_skill(combatant, attacker_weapon)
      # TODO - pilot and passenger vehicle skills
      attacker_weapon_type = FS3Combat.weapon_stat(attacker_weapon, "weapon_type").titleize
      defender_weapon_type = FS3Combat.weapon_stat(combatant.weapon, "weapon_type").titleize
      if (attacker_weapon_type == "Melee" && defender_weapon_type == "Melee")
        skill = FS3Combat.weapon_stat(combatant.weapon, "skill")
      else
        skill = FS3Combat.combatant_type_stat(combatant.combatant_type, "defense_skill")
      end
      skill
    end
    
    def self.hitloc_chart(combatant, crew_hit = false)
      vehicle = combatant.vehicle
      if (!crew_hit && vehicle)
        hitloc_type = FS3Combat.vehicle_stat(vehicle.vehicle_type, "hitloc_chart")
      else
        hitloc_type = FS3Combat.combatant_type_stat(combatant.combatant_type, "hitloc")
      end
      FS3Combat.hitloc(hitloc_type)["areas"]
    end
    
    def self.hitloc_severity(combatant, hitloc)
      hitloc_type = FS3Combat.combatant_type_stat(combatant.combatant_type, "hitloc")
      hitloc_data = FS3Combat.hitloc(hitloc_type)
      vital_areas = hitloc_data["vital_areas"]
      crit_areas = hitloc_data["critical_areas"]
      
      return "Vital" if vital_areas.map { |v| v.titleize }.include?(hitloc.titleize)
      return "Critical" if crit_areas.map { |c| c.titleize }.include?(hitloc.titleize)
      return "Normal"
    end
    
    def self.determine_hitloc(combatant, attacker_net_successes, called_shot = nil)
      return called_shot if (called_shot && attacker_net_successes > 2)

      hitloc_chart = FS3Combat.hitloc_chart(combatant)
            
      if (called_shot)
        locations = hitloc_chart[called_shot]
      else
        locations = hitloc_chart[hitloc_chart.keys.first]
      end
      
      roll = rand(locations.count) + attacker_net_successes
      roll = [roll, locations.count - 1].min
      roll = [0, roll].max
      locations[roll]
    end    
      
    def self.roll_initiative(combatant, ability)
      luck_mod = combatant.luck == "Initiative" ? 3 : 0
      combatant.roll_ability(ability, luck_mod - combatant.total_damage_mod)
    end
    
    def self.check_ammo(combatant, bullets)
      return true if combatant.max_ammo == 0
      combatant.ammo >= bullets
    end
    
    def self.update_ammo(combatant, bullets)
      return nil if combatant.max_ammo == 0

      ammo = combatant.ammo - bullets
      combatant.update(ammo: ammo)
      
      if (ammo == 0)
        t('fs3combat.weapon_clicks_empty', :name => combatant.name)
      else
        nil
      end
    end
  end
end