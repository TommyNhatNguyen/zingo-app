class TopicCategory {
  final String code;
  final String name;
  final String emoji;

  const TopicCategory({
    required this.code,
    required this.name,
    required this.emoji,
  });

  static const List<TopicCategory> all = [
    TopicCategory(code: 'everyday_life', name: 'Everyday Life', emoji: '🏠'),
    TopicCategory(
      code: 'travel_and_transportation',
      name: 'Travel & Transportation',
      emoji: '✈️',
    ),
    TopicCategory(code: 'food_and_dining', name: 'Food & Dining', emoji: '🍽️'),
    TopicCategory(
      code: 'shopping_and_services',
      name: 'Shopping & Services',
      emoji: '🛍️',
    ),
    TopicCategory(
      code: 'health_and_wellness',
      name: 'Health & Wellness',
      emoji: '🏥',
    ),
    TopicCategory(
      code: 'education_and_learning',
      name: 'Education & Learning',
      emoji: '📚',
    ),
    TopicCategory(
      code: 'general_workplace',
      name: 'General Workplace',
      emoji: '💼',
    ),
    TopicCategory(
      code: 'business_and_finance',
      name: 'Business & Finance',
      emoji: '💰',
    ),
    TopicCategory(
      code: 'technology_and_software',
      name: 'Technology & Software',
      emoji: '💻',
    ),
    TopicCategory(
      code: 'design_and_creative',
      name: 'Design & Creative',
      emoji: '🎨',
    ),
    TopicCategory(
      code: 'marketing_and_communications',
      name: 'Marketing & Communications',
      emoji: '📢',
    ),
    TopicCategory(
      code: 'human_resources',
      name: 'Human Resources',
      emoji: '👥',
    ),
    TopicCategory(code: 'legal', name: 'Legal', emoji: '⚖️'),
    TopicCategory(
      code: 'healthcare_and_medical',
      name: 'Healthcare & Medical',
      emoji: '🩺',
    ),
    TopicCategory(
      code: 'engineering_and_manufacturing',
      name: 'Engineering & Manufacturing',
      emoji: '🔧',
    ),
    TopicCategory(
      code: 'hospitality_and_tourism',
      name: 'Hospitality & Tourism',
      emoji: '🏨',
    ),
    TopicCategory(
      code: 'retail_and_customer_service',
      name: 'Retail & Customer Service',
      emoji: '🛒',
    ),
    TopicCategory(
      code: 'real_estate_and_property',
      name: 'Real Estate & Property',
      emoji: '🏘️',
    ),
    TopicCategory(
      code: 'agriculture_and_environment',
      name: 'Agriculture & Environment',
      emoji: '🌱',
    ),
    TopicCategory(
      code: 'media_and_journalism',
      name: 'Media & Journalism',
      emoji: '📰',
    ),
    TopicCategory(
      code: 'government_and_public_sector',
      name: 'Government & Public Sector',
      emoji: '🏛️',
    ),
    TopicCategory(
      code: 'science_and_research',
      name: 'Science & Research',
      emoji: '🔬',
    ),
    TopicCategory(
      code: 'arts_and_performing',
      name: 'Arts & Performing',
      emoji: '🎭',
    ),
    TopicCategory(
      code: 'fitness_and_sports_industry',
      name: 'Fitness & Sports Industry',
      emoji: '💪',
    ),
    TopicCategory(
      code: 'beauty_and_personal_care',
      name: 'Beauty & Personal Care',
      emoji: '💄',
    ),
    TopicCategory(code: 'automotive', name: 'Automotive', emoji: '🚗'),
    TopicCategory(
      code: 'childcare_and_parenting',
      name: 'Childcare & Parenting',
      emoji: '👶',
    ),
    TopicCategory(
      code: 'religion_and_spirituality',
      name: 'Religion & Spirituality',
      emoji: '⛪',
    ),
    TopicCategory(
      code: 'moving_and_relocation',
      name: 'Moving & Relocation',
      emoji: '📦',
    ),
    TopicCategory(
      code: 'gaming_and_esports',
      name: 'Gaming & Esports',
      emoji: '🎮',
    ),
    TopicCategory(
      code: 'nonprofit_and_ngo',
      name: 'Nonprofit & NGO',
      emoji: '🤝',
    ),
    TopicCategory(
      code: 'transportation_and_logistics',
      name: 'Transportation & Logistics',
      emoji: '🚚',
    ),
    TopicCategory(
      code: 'energy_and_utilities',
      name: 'Energy & Utilities',
      emoji: '⚡',
    ),
    TopicCategory(
      code: 'emergency_services',
      name: 'Emergency Services',
      emoji: '🚨',
    ),
  ];
}

class Topic {
  final String code;
  final String name;
  final String categoryCode;

  const Topic({
    required this.code,
    required this.name,
    required this.categoryCode,
  });

  static const List<Topic> all = [
    // Everyday Life
    Topic(
      code: 'daily_routines',
      name: 'Daily Routines',
      categoryCode: 'everyday_life',
    ),
    Topic(code: 'weather', name: 'Weather', categoryCode: 'everyday_life'),
    Topic(
      code: 'making_friends',
      name: 'Making Friends',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'family_and_relationships',
      name: 'Family and Relationships',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'house_and_home',
      name: 'House and Home',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'talking_about_plans',
      name: 'Talking About Plans',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'movies_and_entertainment',
      name: 'Movies and Entertainment',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'sports_and_hobbies',
      name: 'Sports and Hobbies',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'internet_and_social_media',
      name: 'Internet and Social Media',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'music_and_concerts',
      name: 'Music and Concerts',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'books_and_reading',
      name: 'Books and Reading',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'pets_and_animals',
      name: 'Pets and Animals',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'fashion_and_clothing',
      name: 'Fashion and Clothing',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'dating_and_romance',
      name: 'Dating and Romance',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'news_and_current_events',
      name: 'News and Current Events',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'cultural_differences',
      name: 'Cultural Differences',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'environment_and_nature',
      name: 'Environment and Nature',
      categoryCode: 'everyday_life',
    ),
    Topic(
      code: 'volunteering_and_community',
      name: 'Volunteering and Community',
      categoryCode: 'everyday_life',
    ),

    // Travel & Transportation
    Topic(
      code: 'transportation',
      name: 'Transportation',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'asking_for_directions',
      name: 'Asking for Directions',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'at_the_airport',
      name: 'At the Airport',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'hotel_checkin_and_stay',
      name: 'Hotel Check-in and Stay',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'booking_and_reservations',
      name: 'Booking and Reservations',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'immigration_and_customs',
      name: 'Immigration and Customs',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'car_rental_and_driving',
      name: 'Car Rental and Driving',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'public_transit',
      name: 'Public Transit',
      categoryCode: 'travel_and_transportation',
    ),
    Topic(
      code: 'sightseeing_and_tours',
      name: 'Sightseeing and Tours',
      categoryCode: 'travel_and_transportation',
    ),

    // Food & Dining
    Topic(
      code: 'food_and_dining',
      name: 'Food and Dining',
      categoryCode: 'food_and_dining',
    ),
    Topic(
      code: 'ordering_at_restaurants',
      name: 'Ordering at Restaurants',
      categoryCode: 'food_and_dining',
    ),
    Topic(
      code: 'coffee_shop_conversations',
      name: 'Coffee Shop Conversations',
      categoryCode: 'food_and_dining',
    ),
    Topic(
      code: 'food_allergies_and_diets',
      name: 'Food Allergies and Diets',
      categoryCode: 'food_and_dining',
    ),
    Topic(
      code: 'street_food_and_markets',
      name: 'Street Food and Markets',
      categoryCode: 'food_and_dining',
    ),

    // Shopping & Services
    Topic(
      code: 'shopping',
      name: 'Shopping',
      categoryCode: 'shopping_and_services',
    ),
    Topic(
      code: 'online_shopping_and_delivery',
      name: 'Online Shopping and Delivery',
      categoryCode: 'shopping_and_services',
    ),
    Topic(
      code: 'bargaining_and_negotiating_prices',
      name: 'Bargaining and Negotiating Prices',
      categoryCode: 'shopping_and_services',
    ),
    Topic(
      code: 'at_the_bank',
      name: 'At the Bank',
      categoryCode: 'shopping_and_services',
    ),
    Topic(
      code: 'at_the_post_office',
      name: 'At the Post Office',
      categoryCode: 'shopping_and_services',
    ),
    Topic(
      code: 'calling_customer_service',
      name: 'Calling Customer Service',
      categoryCode: 'shopping_and_services',
    ),
    Topic(
      code: 'getting_things_repaired',
      name: 'Getting Things Repaired',
      categoryCode: 'shopping_and_services',
    ),

    // Health & Wellness
    Topic(
      code: 'health_and_wellness',
      name: 'Health and Wellness',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'doctor_visits',
      name: 'Doctor Visits',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'at_the_dentist',
      name: 'At the Dentist',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'pharmacy_and_medicine',
      name: 'Pharmacy and Medicine',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'mental_health_and_wellbeing',
      name: 'Mental Health and Wellbeing',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'emergency_and_first_aid',
      name: 'Emergency and First Aid',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'gym_and_exercise',
      name: 'Gym and Exercise',
      categoryCode: 'health_and_wellness',
    ),
    Topic(
      code: 'health_insurance',
      name: 'Health Insurance',
      categoryCode: 'health_and_wellness',
    ),

    // Education & Learning
    Topic(
      code: 'education_and_school',
      name: 'Education and School',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'university_life',
      name: 'University Life',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'studying_abroad',
      name: 'Studying Abroad',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'exams_and_tests',
      name: 'Exams and Tests',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'group_projects',
      name: 'Group Projects',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'online_courses_and_self_study',
      name: 'Online Courses and Self-Study',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'school_enrollment_and_registration',
      name: 'School Enrollment and Registration',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'tutoring_and_mentoring',
      name: 'Tutoring and Mentoring',
      categoryCode: 'education_and_learning',
    ),
    Topic(
      code: 'libraries_and_research',
      name: 'Libraries and Research',
      categoryCode: 'education_and_learning',
    ),

    // General Workplace
    Topic(
      code: 'job_interviews',
      name: 'Job Interviews',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'first_day_at_work',
      name: 'First Day at Work',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'office_small_talk',
      name: 'Office Small Talk',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'meetings_and_presentations',
      name: 'Meetings and Presentations',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'emails_and_business_writing',
      name: 'Emails and Business Writing',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'phone_and_video_calls',
      name: 'Phone and Video Calls',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'remote_work',
      name: 'Remote Work',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'networking_events',
      name: 'Networking Events',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'teamwork_and_collaboration',
      name: 'Teamwork and Collaboration',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'giving_and_receiving_feedback',
      name: 'Giving and Receiving Feedback',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'performance_reviews',
      name: 'Performance Reviews',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'onboarding_and_training',
      name: 'Onboarding and Training',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'workplace_conflict_resolution',
      name: 'Workplace Conflict Resolution',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'asking_for_a_raise_or_promotion',
      name: 'Asking for a Raise or Promotion',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'resigning_and_farewell',
      name: 'Resigning and Farewell',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'business_travel',
      name: 'Business Travel',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'deadlines_and_time_management',
      name: 'Deadlines and Time Management',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'handling_complaints',
      name: 'Handling Complaints',
      categoryCode: 'general_workplace',
    ),
    Topic(
      code: 'workplace_safety',
      name: 'Workplace Safety',
      categoryCode: 'general_workplace',
    ),

    // Business & Finance
    Topic(
      code: 'business_and_finance',
      name: 'Business and Finance',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'negotiation_and_deals',
      name: 'Negotiation and Deals',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'sales_pitches',
      name: 'Sales Pitches',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'product_demos',
      name: 'Product Demos',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'customer_discovery_calls',
      name: 'Customer Discovery Calls',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'contracts_and_agreements',
      name: 'Contracts and Agreements',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'banking_and_loans',
      name: 'Banking and Loans',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'investment_and_stocks',
      name: 'Investment and Stocks',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'accounting_and_budgets',
      name: 'Accounting and Budgets',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'insurance',
      name: 'Insurance',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'taxes_and_filing',
      name: 'Taxes and Filing',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'startup_and_entrepreneurship',
      name: 'Startup and Entrepreneurship',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'pitching_to_investors',
      name: 'Pitching to Investors',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'freelance_client_calls',
      name: 'Freelance Client Calls',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'pricing_and_proposals',
      name: 'Pricing and Proposals',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'import_and_export',
      name: 'Import and Export',
      categoryCode: 'business_and_finance',
    ),
    Topic(
      code: 'supply_chain_and_logistics',
      name: 'Supply Chain and Logistics',
      categoryCode: 'business_and_finance',
    ),

    // Technology & Software
    Topic(
      code: 'technology',
      name: 'Technology',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'code_reviews',
      name: 'Code Reviews',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'bug_reports_and_debugging',
      name: 'Bug Reports and Debugging',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'system_architecture_discussions',
      name: 'System Architecture Discussions',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'technical_support',
      name: 'Technical Support',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'product_management',
      name: 'Product Management',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'qa_and_testing',
      name: 'QA and Testing',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'devops_and_deployment',
      name: 'DevOps and Deployment',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'data_analysis_and_reports',
      name: 'Data Analysis and Reports',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'cybersecurity',
      name: 'Cybersecurity',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'ai_and_machine_learning',
      name: 'AI and Machine Learning',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'tech_conferences_and_meetups',
      name: 'Tech Conferences and Meetups',
      categoryCode: 'technology_and_software',
    ),
    Topic(
      code: 'it_helpdesk',
      name: 'IT Helpdesk',
      categoryCode: 'technology_and_software',
    ),

    // Design & Creative
    Topic(
      code: 'design_and_creative',
      name: 'Design and Creative',
      categoryCode: 'design_and_creative',
    ),
    Topic(
      code: 'client_feedback_sessions',
      name: 'Client Feedback Sessions',
      categoryCode: 'design_and_creative',
    ),
    Topic(
      code: 'creative_brainstorming',
      name: 'Creative Brainstorming',
      categoryCode: 'design_and_creative',
    ),
    Topic(
      code: 'brand_and_identity_discussions',
      name: 'Brand and Identity Discussions',
      categoryCode: 'design_and_creative',
    ),
    Topic(
      code: 'photography_and_videography',
      name: 'Photography and Videography',
      categoryCode: 'design_and_creative',
    ),
    Topic(
      code: 'content_creation',
      name: 'Content Creation',
      categoryCode: 'design_and_creative',
    ),
    Topic(
      code: 'advertising_and_campaigns',
      name: 'Advertising and Campaigns',
      categoryCode: 'design_and_creative',
    ),

    // Marketing & Communications
    Topic(
      code: 'social_media_marketing',
      name: 'Social Media Marketing',
      categoryCode: 'marketing_and_communications',
    ),
    Topic(
      code: 'seo_and_analytics',
      name: 'SEO and Analytics',
      categoryCode: 'marketing_and_communications',
    ),
    Topic(
      code: 'public_relations',
      name: 'Public Relations',
      categoryCode: 'marketing_and_communications',
    ),
    Topic(
      code: 'event_planning',
      name: 'Event Planning',
      categoryCode: 'marketing_and_communications',
    ),
    Topic(
      code: 'campaign_planning',
      name: 'Campaign Planning',
      categoryCode: 'marketing_and_communications',
    ),
    Topic(
      code: 'market_research',
      name: 'Market Research',
      categoryCode: 'marketing_and_communications',
    ),
    Topic(
      code: 'copywriting_and_editing',
      name: 'Copywriting and Editing',
      categoryCode: 'marketing_and_communications',
    ),

    // Human Resources
    Topic(
      code: 'hiring_and_recruiting',
      name: 'Hiring and Recruiting',
      categoryCode: 'human_resources',
    ),
    Topic(
      code: 'employee_benefits_and_policies',
      name: 'Employee Benefits and Policies',
      categoryCode: 'human_resources',
    ),
    Topic(
      code: 'team_leadership',
      name: 'Team Leadership',
      categoryCode: 'human_resources',
    ),
    Topic(
      code: 'diversity_and_inclusion',
      name: 'Diversity and Inclusion',
      categoryCode: 'human_resources',
    ),

    // Legal
    Topic(
      code: 'legal_consultations',
      name: 'Legal Consultations',
      categoryCode: 'legal',
    ),
    Topic(
      code: 'intellectual_property',
      name: 'Intellectual Property',
      categoryCode: 'legal',
    ),
    Topic(
      code: 'court_and_legal_proceedings',
      name: 'Court and Legal Proceedings',
      categoryCode: 'legal',
    ),
    Topic(
      code: 'compliance_and_regulations',
      name: 'Compliance and Regulations',
      categoryCode: 'legal',
    ),
    Topic(
      code: 'visa_and_immigration_law',
      name: 'Visa and Immigration Law',
      categoryCode: 'legal',
    ),

    // Healthcare & Medical
    Topic(
      code: 'patient_consultations',
      name: 'Patient Consultations',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'medical_terminology',
      name: 'Medical Terminology',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'nursing_and_patient_care',
      name: 'Nursing and Patient Care',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'surgery_and_procedures',
      name: 'Surgery and Procedures',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'lab_results_and_diagnostics',
      name: 'Lab Results and Diagnostics',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'veterinary_care',
      name: 'Veterinary Care',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'physical_therapy',
      name: 'Physical Therapy',
      categoryCode: 'healthcare_and_medical',
    ),
    Topic(
      code: 'elderly_care',
      name: 'Elderly Care',
      categoryCode: 'healthcare_and_medical',
    ),

    // Engineering & Manufacturing
    Topic(
      code: 'construction_site_communication',
      name: 'Construction Site Communication',
      categoryCode: 'engineering_and_manufacturing',
    ),
    Topic(
      code: 'quality_control_and_inspection',
      name: 'Quality Control and Inspection',
      categoryCode: 'engineering_and_manufacturing',
    ),
    Topic(
      code: 'factory_and_production',
      name: 'Factory and Production',
      categoryCode: 'engineering_and_manufacturing',
    ),
    Topic(
      code: 'project_planning_and_blueprints',
      name: 'Project Planning and Blueprints',
      categoryCode: 'engineering_and_manufacturing',
    ),
    Topic(
      code: 'safety_inspections',
      name: 'Safety Inspections',
      categoryCode: 'engineering_and_manufacturing',
    ),
    Topic(
      code: 'equipment_and_machinery',
      name: 'Equipment and Machinery',
      categoryCode: 'engineering_and_manufacturing',
    ),

    // Hospitality & Tourism
    Topic(
      code: 'hotel_front_desk',
      name: 'Hotel Front Desk',
      categoryCode: 'hospitality_and_tourism',
    ),
    Topic(
      code: 'tour_guiding',
      name: 'Tour Guiding',
      categoryCode: 'hospitality_and_tourism',
    ),
    Topic(
      code: 'airline_and_flight_crew',
      name: 'Airline and Flight Crew',
      categoryCode: 'hospitality_and_tourism',
    ),
    Topic(
      code: 'cruise_and_resort',
      name: 'Cruise and Resort',
      categoryCode: 'hospitality_and_tourism',
    ),
    Topic(
      code: 'spa_and_wellness_center',
      name: 'Spa and Wellness Center',
      categoryCode: 'hospitality_and_tourism',
    ),
    Topic(
      code: 'bartending_and_barista',
      name: 'Bartending and Barista',
      categoryCode: 'hospitality_and_tourism',
    ),
    Topic(
      code: 'catering_and_banquet',
      name: 'Catering and Banquet',
      categoryCode: 'hospitality_and_tourism',
    ),

    // Retail & Customer Service
    Topic(
      code: 'retail_sales_floor',
      name: 'Retail Sales Floor',
      categoryCode: 'retail_and_customer_service',
    ),
    Topic(
      code: 'cashier_and_checkout',
      name: 'Cashier and Checkout',
      categoryCode: 'retail_and_customer_service',
    ),
    Topic(
      code: 'visual_merchandising',
      name: 'Visual Merchandising',
      categoryCode: 'retail_and_customer_service',
    ),
    Topic(
      code: 'call_center_and_support',
      name: 'Call Center and Support',
      categoryCode: 'retail_and_customer_service',
    ),
    Topic(
      code: 'luxury_and_high_end_retail',
      name: 'Luxury and High-End Retail',
      categoryCode: 'retail_and_customer_service',
    ),

    // Real Estate & Property
    Topic(
      code: 'renting_an_apartment',
      name: 'Renting an Apartment',
      categoryCode: 'real_estate_and_property',
    ),
    Topic(
      code: 'buying_and_selling_property',
      name: 'Buying and Selling Property',
      categoryCode: 'real_estate_and_property',
    ),
    Topic(
      code: 'property_management',
      name: 'Property Management',
      categoryCode: 'real_estate_and_property',
    ),
    Topic(
      code: 'home_renovation',
      name: 'Home Renovation',
      categoryCode: 'real_estate_and_property',
    ),
    Topic(
      code: 'talking_to_landlords',
      name: 'Talking to Landlords',
      categoryCode: 'real_estate_and_property',
    ),

    // Agriculture & Environment
    Topic(
      code: 'farming_and_agriculture',
      name: 'Farming and Agriculture',
      categoryCode: 'agriculture_and_environment',
    ),
    Topic(
      code: 'food_safety_and_standards',
      name: 'Food Safety and Standards',
      categoryCode: 'agriculture_and_environment',
    ),
    Topic(
      code: 'sustainability_and_green_energy',
      name: 'Sustainability and Green Energy',
      categoryCode: 'agriculture_and_environment',
    ),
    Topic(
      code: 'wildlife_and_conservation',
      name: 'Wildlife and Conservation',
      categoryCode: 'agriculture_and_environment',
    ),

    // Media & Journalism
    Topic(
      code: 'interviewing_people',
      name: 'Interviewing People',
      categoryCode: 'media_and_journalism',
    ),
    Topic(
      code: 'podcasting_and_broadcasting',
      name: 'Podcasting and Broadcasting',
      categoryCode: 'media_and_journalism',
    ),
    Topic(
      code: 'film_and_tv_production',
      name: 'Film and TV Production',
      categoryCode: 'media_and_journalism',
    ),
    Topic(
      code: 'publishing_and_editing',
      name: 'Publishing and Editing',
      categoryCode: 'media_and_journalism',
    ),

    // Government & Public Sector
    Topic(
      code: 'government_services',
      name: 'Government Services',
      categoryCode: 'government_and_public_sector',
    ),
    Topic(
      code: 'public_speaking_and_debates',
      name: 'Public Speaking and Debates',
      categoryCode: 'government_and_public_sector',
    ),
    Topic(
      code: 'diplomacy_and_international_relations',
      name: 'Diplomacy and International Relations',
      categoryCode: 'government_and_public_sector',
    ),
    Topic(
      code: 'military_and_defense',
      name: 'Military and Defense',
      categoryCode: 'government_and_public_sector',
    ),
    Topic(
      code: 'social_work',
      name: 'Social Work',
      categoryCode: 'government_and_public_sector',
    ),

    // Science & Research
    Topic(
      code: 'conference_presentations',
      name: 'Conference Presentations',
      categoryCode: 'science_and_research',
    ),
    Topic(
      code: 'thesis_defense',
      name: 'Thesis Defense',
      categoryCode: 'science_and_research',
    ),
    Topic(
      code: 'peer_review_and_publishing',
      name: 'Peer Review and Publishing',
      categoryCode: 'science_and_research',
    ),
    Topic(
      code: 'grant_writing_and_funding',
      name: 'Grant Writing and Funding',
      categoryCode: 'science_and_research',
    ),
    Topic(
      code: 'clinical_trials',
      name: 'Clinical Trials',
      categoryCode: 'science_and_research',
    ),

    // Arts & Performing
    Topic(
      code: 'arts_and_performing',
      name: 'Arts and Performing',
      categoryCode: 'arts_and_performing',
    ),
    Topic(
      code: 'theater_and_performing_arts',
      name: 'Theater and Performing Arts',
      categoryCode: 'arts_and_performing',
    ),
    Topic(
      code: 'music_production',
      name: 'Music Production',
      categoryCode: 'arts_and_performing',
    ),
    Topic(
      code: 'dance_and_choreography',
      name: 'Dance and Choreography',
      categoryCode: 'arts_and_performing',
    ),
    Topic(
      code: 'auditions_and_casting',
      name: 'Auditions and Casting',
      categoryCode: 'arts_and_performing',
    ),

    // Fitness & Sports Industry
    Topic(
      code: 'personal_training',
      name: 'Personal Training',
      categoryCode: 'fitness_and_sports_industry',
    ),
    Topic(
      code: 'yoga_and_meditation',
      name: 'Yoga and Meditation',
      categoryCode: 'fitness_and_sports_industry',
    ),
    Topic(
      code: 'sports_commentary',
      name: 'Sports Commentary',
      categoryCode: 'fitness_and_sports_industry',
    ),
    Topic(
      code: 'outdoor_adventures',
      name: 'Outdoor Adventures',
      categoryCode: 'fitness_and_sports_industry',
    ),

    // Beauty & Personal Care
    Topic(
      code: 'hair_salon_conversations',
      name: 'Hair Salon Conversations',
      categoryCode: 'beauty_and_personal_care',
    ),
    Topic(
      code: 'tattoo_and_piercing_studios',
      name: 'Tattoo and Piercing Studios',
      categoryCode: 'beauty_and_personal_care',
    ),

    // Automotive
    Topic(
      code: 'car_buying_and_dealerships',
      name: 'Car Buying and Dealerships',
      categoryCode: 'automotive',
    ),
    Topic(
      code: 'auto_repair_and_mechanics',
      name: 'Auto Repair and Mechanics',
      categoryCode: 'automotive',
    ),
    Topic(
      code: 'driving_lessons',
      name: 'Driving Lessons',
      categoryCode: 'automotive',
    ),
    Topic(
      code: 'ride_sharing_and_taxis',
      name: 'Ride-Sharing and Taxis',
      categoryCode: 'automotive',
    ),

    // Childcare & Parenting
    Topic(
      code: 'parent_teacher_meetings',
      name: 'Parent-Teacher Meetings',
      categoryCode: 'childcare_and_parenting',
    ),
    Topic(
      code: 'daycare_and_babysitting',
      name: 'Daycare and Babysitting',
      categoryCode: 'childcare_and_parenting',
    ),
    Topic(
      code: 'parenting_and_child_development',
      name: 'Parenting and Child Development',
      categoryCode: 'childcare_and_parenting',
    ),
    Topic(
      code: 'playground_and_playdates',
      name: 'Playground and Playdates',
      categoryCode: 'childcare_and_parenting',
    ),

    // Religion & Spirituality
    Topic(
      code: 'religious_gatherings',
      name: 'Religious Gatherings',
      categoryCode: 'religion_and_spirituality',
    ),
    Topic(
      code: 'charity_and_fundraising',
      name: 'Charity and Fundraising',
      categoryCode: 'religion_and_spirituality',
    ),

    // Moving & Relocation
    Topic(
      code: 'moving_to_a_new_city',
      name: 'Moving to a New City',
      categoryCode: 'moving_and_relocation',
    ),
    Topic(
      code: 'living_abroad',
      name: 'Living Abroad',
      categoryCode: 'moving_and_relocation',
    ),
    Topic(
      code: 'visa_and_passport_applications',
      name: 'Visa and Passport Applications',
      categoryCode: 'moving_and_relocation',
    ),

    // Gaming & Esports
    Topic(
      code: 'gaming_and_esports',
      name: 'Gaming and Esports',
      categoryCode: 'gaming_and_esports',
    ),
    Topic(
      code: 'game_development',
      name: 'Game Development',
      categoryCode: 'gaming_and_esports',
    ),
    Topic(
      code: 'streaming_and_content',
      name: 'Streaming and Content',
      categoryCode: 'gaming_and_esports',
    ),

    // Nonprofit & NGO
    Topic(
      code: 'community_organizing',
      name: 'Community Organizing',
      categoryCode: 'nonprofit_and_ngo',
    ),

    // Transportation & Logistics
    Topic(
      code: 'truck_driving_and_delivery',
      name: 'Truck Driving and Delivery',
      categoryCode: 'transportation_and_logistics',
    ),
    Topic(
      code: 'warehouse_and_inventory',
      name: 'Warehouse and Inventory',
      categoryCode: 'transportation_and_logistics',
    ),
    Topic(
      code: 'shipping_and_freight',
      name: 'Shipping and Freight',
      categoryCode: 'transportation_and_logistics',
    ),
    Topic(
      code: 'courier_and_last_mile_delivery',
      name: 'Courier and Last-Mile Delivery',
      categoryCode: 'transportation_and_logistics',
    ),

    // Energy & Utilities
    Topic(
      code: 'oil_and_gas_industry',
      name: 'Oil and Gas Industry',
      categoryCode: 'energy_and_utilities',
    ),
    Topic(
      code: 'renewable_energy',
      name: 'Renewable Energy',
      categoryCode: 'energy_and_utilities',
    ),
    Topic(
      code: 'electrical_and_plumbing_work',
      name: 'Electrical and Plumbing Work',
      categoryCode: 'energy_and_utilities',
    ),

    // Emergency Services
    Topic(
      code: 'calling_emergency_services',
      name: 'Calling Emergency Services',
      categoryCode: 'emergency_services',
    ),
    Topic(
      code: 'firefighting',
      name: 'Firefighting',
      categoryCode: 'emergency_services',
    ),
    Topic(
      code: 'disaster_preparedness',
      name: 'Disaster Preparedness',
      categoryCode: 'emergency_services',
    ),
  ];
}
