class GroupUserValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      # カスタムバリデーションを記述
      binding.pry
      # 0がスタッフかどうかわからんけど・・・。0と仮定して 
      # value.position == 0 
      # 関連付けをつけておく
      # 以下はどレでも良いと思う。

      
      if value.position == 0 ? && value.user_group.precent? && value.user_group.count < 1
        binding.pry
        # ここを明日記述すること
        # too_longを修正予定
        record.errors.add(attribute, :too_long, count: max)
      end

      # 存在するか？
    #   value.user_group.precent?

      # 1より多いか？
    #   value.user_group.count < 1


    # メソッドを分離するのもよし
    end
  end