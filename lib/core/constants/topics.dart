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
    TopicCategory(
      code: 'general_workplace',
      name: 'General Workplace',
      emoji: '💼',
    ),
    TopicCategory(
      code: 'technology_and_software',
      name: 'Technology & Software',
      emoji: '💻',
    ),
    TopicCategory(
      code: 'business_and_finance',
      name: 'Business & Finance',
      emoji: '💰',
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
      code: 'healthcare_and_medical',
      name: 'Healthcare & Medical',
      emoji: '🩺',
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
    TopicCategory(
      code: 'education_and_learning',
      name: 'Education & Learning',
      emoji: '📚',
    ),
    TopicCategory(
      code: 'design_and_creative',
      name: 'Design & Creative',
      emoji: '🎨',
    ),
    TopicCategory(
      code: 'travel_and_transportation',
      name: 'Travel & Transportation',
      emoji: '✈️',
    ),
    TopicCategory(code: 'food_and_dining', name: 'Food & Dining', emoji: '🍽️'),
    TopicCategory(
      code: 'health_and_wellness',
      name: 'Health & Wellness',
      emoji: '🏥',
    ),
    TopicCategory(
      code: 'real_estate_and_property',
      name: 'Real Estate & Property',
      emoji: '🏘️',
    ),
    TopicCategory(
      code: 'shopping_and_services',
      name: 'Shopping & Services',
      emoji: '🛍️',
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
  ];
}
