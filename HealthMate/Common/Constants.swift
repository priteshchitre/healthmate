//
//  Constants.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 7/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//
import UIKit

struct Constants {
    
    static let SHARED_SECRET_KEY = "702f8c1ba9a94d4dbf9070afb425b9ea"
    static let ACCESS_TOKEN = "shhh2020heathMateX"
    
    static let PRIVACY_POLICY = "https://gethealthmate.com/privacy-policy"
    static let EULA = "https://gethealthmate.com/eula"
    static let SUPPORT_EMAIL = "support@gethealthmate.com"
    
    static let BundleId = "com.acodecreative.healthmate"
    static let APP_TITLE = "Health Mate"
    static let APP_URL = "https://apps.apple.com/us/app/healthmate-calorie-counter/id1536629326"
    static let APP_ID = "1536629326"

    static let TENJIN_KEY = "CDSXTDAMB7LWROYV1AWX5CFC3TUWLTWV"
    static let FLURRY_KEY = "HVQ3NJ9W94664JRK6MMR"
    static let ONESIGNAL_API_KEY = "acbeea84-9b2f-4220-a94a-43c52fd48c4e"
    static let REVENUE_CAT_KEY = "hsfIfCgNiRKLnGgencxBjjVEqnGEkFue"
    
    static let LOCAL_DASHBOARD = "LocalDashboard"
    static let LOCAL_SUBSCRIPTION = "LocalSubscription"
    static let LOCAL_TRACK_VIEW = "LocalTrackView"
    static let LOCAL_FOOD_LIST = "LocalFoodList"
    static let LOCAL_FOOD_DETAILS = "LocalFoodDetails"
    static let LOCAL_CUSTOM_FOOD = "LocalCustomFood"
    static let LOCAL_PROGRESS = "LocalProgress"
    static let LOCAL_RECIPE = "LocalRecipe"
    static let LOCAL_RECIPE_DETAILS = "LocalRecipeDetails"
    static let LOCAL_WORKOUT = "LocalWorkout"
    static let LOCAL_WORKOUT_DETAILS = "LocalWorkoutDetails"
    static let LOCAL_EXCERCISE = "LocalExcercise"
    static let LOCAL_SETTINGS = "LocalSettings"
    static let LOCAL_APP_PREFERENCES = "LocalAppPreferences"
    static let LOCAL_USER_PROFILE = "LocalUserProfile"

    static let CONSUMED_DATE_FORMATE = "MM-dd-yyyy"
}
enum INPUT_TYPE : String {
    case WEIGHT = "WEIGHT", HEIGHT = "HEIGHT", EXPRECTED_WEIGHT = "EXPRECTED_WEIGHT", NAME = "NAME"
}
enum PLANS : String {
    case WEEKLY = "healthmate_premium_weekly_7", MONTHLY = "healthmate_premium_monthly", YEARLY = "healthmate_premium_yearly", WEEKLY_3DAYS_TRIAL = "healthmate_premium_weekly"
}
enum ACTIVITY_LEVEL : String {
    case SENDETARY = "sedentary", LIGHTLY_ACTIVE = "lightly_active", ACTIVE = "active", VERY_ACTIVE = "very_active"
}
enum RECIPE_DIETS : String {
    case OMNIVORE = "omnivore", PESCATARIAN = "pescatarian", VEGETARIAN = "vegetarian", VEGAN = "vegan"
}
enum RECIPE_MEALS : String {
    case BREAKFAST = "breakfast", SNACK = "snack", LUNCH_DINNER = "lunch_dinner"
}
enum WEIGHT_PLAN : String {
    case MILD_WEIGHT_GAIN = "mild_weight_gain", WEIGHT_GAIN = "weight_gain", CHALLENGING_WEIGHT_GAIN = "challenging_weight_gain", EXTREME_WEIGHT_GAIN = "extreme_weight_gain", MILD_WEIGHT_LOSS = "mild_weight_loss", WEIGHT_LOSS = "weight_loss", CHALLENGING_WEIGHT_LOSS = "challenging_weight_loss", EXTREME_WEIGHT_LOSS = "extreme_weight_loss", MAINTAIN_WEIGHT = "maintain_weight"
}
enum DURATION : String {
    case WEEKLY = "Weekly", MONTHLY = "Monthly", YEARLY = "yearly"
}
enum PROGRESS : String {
    case CALORIE = "Calorie", WATER = "Water", CALORIE_BURED = "CalorieBurned", WEIGHT = "Weight"
}
