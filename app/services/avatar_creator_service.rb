class AvatarCreatorService < ApplicationService
  include HTTParty

  def initialize(user)
    @user = user
  end

  def call
    gender = getGender
    url = "https://avatars.dicebear.com/v2/#{gender}/#{@user.name.gsub(/\s+/, "")}.svg"
    res = HTTParty.get(url)

    {
      url: url,
      svg: res.body
    }
  end

  def avataaar
    # these are cool but don't work in mals_app currently
    accessoriesType = getAccessoriesType
    clotheType = getClotheType
    eyebrowType = getEyebrowType
    eyeType = getEyeType
    facialHairType = getFacialHairType
    hairColor = getHairColor
    mouthType = getMouthType
    skinColor = getSkinColor
    topType = getTopType

    "https://avataaars.io/?avatarStyle=Circle&topType=#{topType}&accessoriesType=#{accessoriesType}&hairColor=#{hairColor}&facialHairType=#{facialHairType}&clotheType=#{clotheType}&eyeType=#{eyeType}&eyebrowType=#{eyebrowType}&mouthType=#{mouthType}&skinColor=#{skinColor}"
  end

  private
    def getGender
      [
        'male',
        'female'
      ].sample
    end

    def getAccessoriesType
      [
        'Blank',
        'Kurt',
        'Prescription01',
        'Prescription02',
        'Round',
        'Sunglasses',
        'Wayfarers'
      ].sample
    end

    def getClotheType
      [
        'BlazerShirt',
        'BlazerSweater',
        'CollarSweater',
        'GraphicShirt',
        'Hoodie',
        'Overall',
        'ShirtCrewNeck',
        'ShirtScoopNeck',
        'ShirtVNeck'
      ].sample
    end

    def getEyebrowType
      [
        'Angry',
        'AngryNatural',
        'Default',
        'DefaultNatural',
        'FlatNatural',
        'RaisedExcited',
        'RaisedExcitedNatural',
        'SadConcerned',
        'SadConcernedNatural',
        'UnibrowNatural',
        'UpDown',
        'UpDownNatural'
      ].sample
    end

    def getEyeType
      [
        'Close',
        'Cry',
        'Default',
        'Dizzy',
        'EyeRoll',
        'Happy',
        'Hearts',
        'Side',
        'Squint',
        'Surprised',
        'Wink',
        'WinkWacky'
      ].sample
    end

    def getFacialHairType
      facialHairTypes = [
        'Blank',
        'BeardMedium',
        'BeardLight',
        'BeardMagestic',
        'MoustacheFancy',
        'MoustacheMagnum'
      ]

      # hack to weight "Blank"
      for x in 0..25
        facialHairTypes.push('Blank')
      end

      facialHairTypes.sample
    end

    def getHairColor
      [
        'Auburn',
        'Black',
        'Blonde',
        'BlondeGolden',
        'Brown',
        'BrownDark',
        'PastelPink',
        'Platinum',
        'Red',
        'SilverGray'
      ].sample
    end

    def getMouthType
      [
        'Concerned',
        'Default',
        'Disbelief',
        'Eating',
        'Grimace',
        'Sad',
        'ScreamOpen',
        'Serious',
        'Smile',
        'Tongue',
        'Twinkle'
      ].sample
    end

    def getSkinColor
      [
        'Tanned',
        'Yellow',
        'Pale',
        'Light',
        'Brown',
        'DarkBrown',
        'Black'
      ].sample
    end

    def getTopType
      [
        'Eyepatch',
        'Hat',
        'Hijab',
        'LongHairBigHair',
        'LongHairBob',
        'LongHairBun',
        'LongHairCurly',
        'LongHairCurvy',
        'LongHairDreads',
        'LongHairFrida',
        'LongHairFro',
        'LongHairFroBand',
        'LongHairMiaWallace',
        'LongHairNotTooLong',
        'LongHairShavedSides',
        'LongHairStraight',
        'LongHairStraight2',
        'LongHairStraightStrand',
        'NoHair',
        'ShortHairDreads01',
        'ShortHairDreads02',
        'ShortHairFrizzle',
        'ShortHairShaggyMullet',
        'ShortHairShortCurly',
        'ShortHairShortFlat',
        'ShortHairShortRound',
        'ShortHairShortWaved',
        'ShortHairSides',
        'ShortHairTheCaesar',
        'ShortHairTheCaesarSidePart',
        'Turban',
        'WinterHat1',
        'WinterHat2',
        'WinterHat3',
        'WinterHat4'
      ].sample
    end
end
