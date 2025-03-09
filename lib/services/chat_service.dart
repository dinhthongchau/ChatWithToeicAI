// services/chat_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class ChatService {
  final String apiKey;

  ChatService(this.apiKey);

  Future<String?> generateResponse(String input) async {
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
    );

    final response = await model.generateContent([
    Content.text('input: When user gives a word, translate that and provide selling words that involve TOEIC, and give examples and translate to Vietnamese.'),
    Content.text('output: Translate the word \'opportunity\' to Vietnamese. Example: \'This job offers a great opportunity for growth.\' Translate: \'Công việc này mang lại cơ hội tuyệt vời để phát triển.\'  Selling words related to \'opportunity\' in a TOEIC context could be ( just 5 word ussually use) :  \'prospect\', \'chance\', \'opening\', \'vacancy\', \'career \', expansion offers excellent prospects for new employees.\' Translate: \'Sự mở rộng của công ty mang lại triển vọng tuyệt vời cho nhân viên mới.\''),
    Content.text('input: When the user asks about grammar rules, provide a brief explanation and examples.'),
    Content.text('output: Explain the difference between \'present perfect\' and \'simple past\'. Present perfect: \'I have seen that movie.\' (Focuses on the present result of a past action) Simple past: \'I saw that movie yesterday.\' (Focuses on a completed action at a specific time in the past).  Present perfect emphasizes the connection to the present, while simple past emphasizes the completion of the action.  Another example: Present Perfect: \'She has traveled to Europe.\' (She has the experience of traveling to Europe). Simple Past: \'She traveled to Europe last summer.\' (The specific time of her trip is important).'),
    Content.text('input: When user gives a TOEIC vocabulary word, provide synonyms and antonyms.'),
    Content.text('output: For the word \'efficient\', provide synonyms like \'effective\', \'productive\', \'organized\', \'capable\', \'competent\', \'streamlined\', \'economical\', \'resourceful\'.  Antonyms include \'inefficient\', \'unproductive\', \'wasteful\', \'disorganized\', \'incompetent\', \'ineffective\'. Example in a sentence: \'The new software made the process much more efficient.\' Translate: \'Phần mềm mới đã làm cho quá trình hiệu quả hơn rất nhiều.\''),
    Content.text('input: When user asks for listening comprehension tips, provide strategies.'),
    Content.text('output: Suggest listening to English podcasts, taking notes on key ideas, and repeating phrases to improve understanding.  Other tips include:  Predicting the content, focusing on keywords, practicing with different accents, improving vocabulary, and working on listening in noisy environments.  For example, when listening to a podcast, try to summarize each segment in your own words. This helps with active listening and comprehension.'),
    Content.text('input: When user requests examples of formal email writing, provide a sample.'),
    Content.text('output: Sample: \'Dear Mr. Smith, I hope this message finds you well. I am writing to inquire about the marketing manager position advertised on your website. My resume is attached for your review. I look forward to hearing from you soon. Sincerely, [Your Name]\' Translate: \'Kính gửi ông Smith, tôi hy vọng bạn khỏe mạnh. Tôi viết thư này để hỏi về vị trí quản lý tiếp thị được quảng cáo trên trang web của bạn. Hồ sơ của tôi được đính kèm để bạn xem xét. Tôi rất mong nhận được phản hồi từ bạn sớm. Trân trọng, [Tên của bạn]\''),
    Content.text('input: When user inquires about core TOEIC idioms, explain and provide examples.'),
    Content.text('output: Idiom: \'Get down to business\'. Meaning: To start focusing on the main topic or task. Example: \'Now that everyone is here, let\'s get down to business and discuss the quarterly report.\' Translate: \'Bây giờ mọi người đã ở đây, hãy bắt đầu vào việc chính và thảo luận về báo cáo hàng quý.\' Another idiom: \'Think outside the box\'. Meaning: To think creatively and unconventionally. Example: \'We need to think outside the box to find a solution to this problem.\' Translate: \'Chúng ta cần suy nghĩ khác biệt để tìm ra giải pháp cho vấn đề này.\''),
    Content.text('input: When user asks about effective study methods for TOEIC, provide suggestions.'),
    Content.text('output: Recommend using flashcards for vocabulary, practicing with TOEIC practice tests, and joining study groups.  Other effective methods include:  Setting realistic goals, creating a study schedule, focusing on weak areas, using online resources, and practicing regularly.  For example, dedicate at least 30 minutes each day to vocabulary review.'),
    Content.text('input: When user needs clarification on a specific TOEIC section, explain it.'),
    Content.text('output: TOEIC Reading section measures reading comprehension. It includes passages and questions about the main idea, details, and vocabulary.  The reading section often includes single passages, double passages, and sentence completion questions.  It tests your ability to understand written English in a business context.  Time management is crucial in this section.'),
    Content.text('input: When user provides a TOEIC sentence, ask for corrections or improvements.'),
    Content.text('output: Sentence: \'Me and my colleague went to the meeting.\' Corrected: \'My colleague and I went to the meeting.\'  The pronoun \'me\' should be \'I\' in the subject position.  Another example: \'The report is more better than the previous one.\' Corrected: \'The report is better than the previous one.\'  Avoid using double comparatives.'),
    Content.text('input: When user wants to improve their speaking skills, suggest techniques.'),
    Content.text('output: Practice speaking with a language partner, record yourself, and use language learning apps for speaking exercises.  Other techniques include:  Shadowing native speakers, focusing on pronunciation, practicing core phrases, and participating in conversations.  For example, record yourself reading a passage and then compare it to a native speaker\'s recording.'),
    Content.text('input: When user asks about time management during the TOEIC test, give tips.'),
    Content.text('output: Advise to read instructions carefully, allocate time per section, and practice with timed mock tests.  A good strategy is to divide the total time by the number of questions in each section.  It\'s also important to practice pacing yourself so you don\'t spend too much time on any one question.  If you\'re unsure of an answer, it\'s often better to make an educated guess than to leave it blank.'),
    Content.text('input: When user gives a phrase, ask for its use in a business context.'),
    Content.text('output: Phrase: \'Circle back\'. Business context: \'Let\'s circle back on this topic at our next meeting.\'  In this context, \'circle back\' means to revisit or discuss something again later.  Another example: Phrase: \'On the same page\'. Business context: \'We need to make sure we\'re all on the same page regarding the project timeline.\'  Here, \'on the same page\' means to be in agreement or have the same understanding.'),
    Content.text('input: When user asks about the TOEIC Writing test, describe its format and scoring.'),
    Content.text('output: The TOEIC Writing test consists of eight tasks: two sentence completion tasks, two picture description tasks, and four opinion essay tasks.  The sentence completion tasks assess grammar and vocabulary, the picture description tasks evaluate the ability to describe visual information, and the opinion essay tasks measure the ability to express and support an opinion in writing.  Each section is scored separately, and the total score ranges from 0 to 200.  The writing test assesses clarity, coherence, grammar, vocabulary, and organization.'),
    Content.text('input: When user asks about the TOEIC Speaking test, describe its format and scoring.'),
    Content.text('output: The TOEIC Speaking test includes eleven tasks: two read aloud tasks, one picture description task, three response to questions tasks, and five propose a solution tasks. The read aloud tasks assess pronunciation and fluency, the picture description task evaluates the ability to describe visual information, the response to questions tasks measure the ability to provide relevant and coherent answers, and the propose a solution tasks measure the ability to offer solutions to problems. Each section is scored separately, and the total score ranges from 0 to 200. The speaking test assesses pronunciation, intonation, fluency, vocabulary, grammar, and coherence.'),
    Content.text('input: When user asks for tips on improving vocabulary for the TOEIC, provide suggestions.'),
    Content.text('output: Recommend learning root words, prefixes, and suffixes, using flashcards, reading English articles and books, and using vocabulary learning apps.  Focus on learning words in context, rather than memorizing lists of words.  For example, when you encounter a new word, try to guess its meaning from the surrounding words and then look it up in a dictionary.  Also, try to use new words in your own writing and speaking to reinforce your learning.'),
    Content.text('input: When user asks about how to prepare for the TOEIC Listening Part 1 (Photographs), provide tips.'),
    Content.text('output: Focus on identifying the main subject and action in the photograph.  Listen carefully to the descriptions and pay attention to details.  Practice identifying core vocabulary related to workplace settings and activities.  For example, if you see a photograph of someone working at a computer, you might expect to hear words like \'typing\', \'keyboard\', \'monitor\', \'office\', or \'desk\'.'),
    Content.text('input: When user asks about how to prepare for the TOEIC Listening Part 2 (Question-Response), provide tips.'),
    Content.text('output: Practice identifying different question types (e.g., who, what, where, when, why, how).  Pay attention to the intonation of the speaker, as this can often give clues about the type of question being asked.  Focus on understanding the key words in the question and response.  Practice anticipating possible responses.  For example, if you hear a question like \'When will the meeting start?\', you might expect to hear a response that includes a time or date.'),
    Content.text('input: When user asks about how to prepare for the TOEIC Listening Part 3 (Short Conversations), provide tips.'),
    Content.text('output: Read the questions before listening to the conversation.  This will help you focus on the information that is relevant to the questions.  Pay attention to the relationship between the speakers and the context of the conversation.  Take notes on key information.  Practice identifying the main idea and supporting details of the conversation.  For example, try to'),
    // Content.text("""
    // You are a TOEIC assistant. You will ONLY answer questions related to TOEIC. 
    // If the question is NOT about TOEIC, do NOT answer. Simply reply with: 
    // 'This chatbot only provides responses related to TOEIC. Please ask something about TOEIC.'
    // """),
    Content.text('input:  $input'),
    Content.text('output: '),
    ]);
    return response.text;
  }
}

// import 'dart:io';
//
// import 'package:google_generative_ai/google_generative_ai.dart';
//
// void main() async {
//   var apiKeyString = 'AIzaSyA6eb5jge_GI5NS29exFS7mfZj4RHrcAsY';
//   final apiKey = apiKeyString;
//   if (apiKey == null) {
//     stderr.writeln(r'No $GEMINI_API_KEY environment variable');
//     exit(1);
//   }
//
//   final model = GenerativeModel(
//     model: 'gemini-2.0-flash',
//     apiKey: apiKey,
//     generationConfig: GenerationConfig(
//
//       temperature: 1,
//       topK: 40,
//       topP: 0.95,
//       maxOutputTokens: 8192,
//       responseMimeType: 'text/plain',
//     ),
//   );
//
//   final response = await model.generateContent([
//
//     Content.text('input: When user gives a word, translate that and provide selling words that involve TOEIC, and give examples and translate to Vietnamese.'),
//     Content.text('output: Translate the word \'opportunity\' to Vietnamese. Example: \'This job offers a great opportunity for growth.\' Translate: \'Công việc này mang lại cơ hội tuyệt vời để phát triển.\'  Selling words related to \'opportunity\' in a TOEIC context could be ( just 5 word ussually use) :  \'prospect\', \'chance\', \'opening\', \'vacancy\', \'career \', expansion offers excellent prospects for new employees.\' Translate: \'Sự mở rộng của công ty mang lại triển vọng tuyệt vời cho nhân viên mới.\''),
//     Content.text('input: When the user asks about grammar rules, provide a brief explanation and examples.'),
//     Content.text('output: Explain the difference between \'present perfect\' and \'simple past\'. Present perfect: \'I have seen that movie.\' (Focuses on the present result of a past action) Simple past: \'I saw that movie yesterday.\' (Focuses on a completed action at a specific time in the past).  Present perfect emphasizes the connection to the present, while simple past emphasizes the completion of the action.  Another example: Present Perfect: \'She has traveled to Europe.\' (She has the experience of traveling to Europe). Simple Past: \'She traveled to Europe last summer.\' (The specific time of her trip is important).'),
//     Content.text('input: When user gives a TOEIC vocabulary word, provide synonyms and antonyms.'),
//     Content.text('output: For the word \'efficient\', provide synonyms like \'effective\', \'productive\', \'organized\', \'capable\', \'competent\', \'streamlined\', \'economical\', \'resourceful\'.  Antonyms include \'inefficient\', \'unproductive\', \'wasteful\', \'disorganized\', \'incompetent\', \'ineffective\'. Example in a sentence: \'The new software made the process much more efficient.\' Translate: \'Phần mềm mới đã làm cho quá trình hiệu quả hơn rất nhiều.\''),
//     Content.text('input: When user asks for listening comprehension tips, provide strategies.'),
//     Content.text('output: Suggest listening to English podcasts, taking notes on key ideas, and repeating phrases to improve understanding.  Other tips include:  Predicting the content, focusing on keywords, practicing with different accents, improving vocabulary, and working on listening in noisy environments.  For example, when listening to a podcast, try to summarize each segment in your own words. This helps with active listening and comprehension.'),
//     Content.text('input: When user requests examples of formal email writing, provide a sample.'),
//     Content.text('output: Sample: \'Dear Mr. Smith, I hope this message finds you well. I am writing to inquire about the marketing manager position advertised on your website. My resume is attached for your review. I look forward to hearing from you soon. Sincerely, [Your Name]\' Translate: \'Kính gửi ông Smith, tôi hy vọng bạn khỏe mạnh. Tôi viết thư này để hỏi về vị trí quản lý tiếp thị được quảng cáo trên trang web của bạn. Hồ sơ của tôi được đính kèm để bạn xem xét. Tôi rất mong nhận được phản hồi từ bạn sớm. Trân trọng, [Tên của bạn]\''),
//     Content.text('input: When user inquires about core TOEIC idioms, explain and provide examples.'),
//     Content.text('output: Idiom: \'Get down to business\'. Meaning: To start focusing on the main topic or task. Example: \'Now that everyone is here, let\'s get down to business and discuss the quarterly report.\' Translate: \'Bây giờ mọi người đã ở đây, hãy bắt đầu vào việc chính và thảo luận về báo cáo hàng quý.\' Another idiom: \'Think outside the box\'. Meaning: To think creatively and unconventionally. Example: \'We need to think outside the box to find a solution to this problem.\' Translate: \'Chúng ta cần suy nghĩ khác biệt để tìm ra giải pháp cho vấn đề này.\''),
//     Content.text('input: When user asks about effective study methods for TOEIC, provide suggestions.'),
//     Content.text('output: Recommend using flashcards for vocabulary, practicing with TOEIC practice tests, and joining study groups.  Other effective methods include:  Setting realistic goals, creating a study schedule, focusing on weak areas, using online resources, and practicing regularly.  For example, dedicate at least 30 minutes each day to vocabulary review.'),
//     Content.text('input: When user needs clarification on a specific TOEIC section, explain it.'),
//     Content.text('output: TOEIC Reading section measures reading comprehension. It includes passages and questions about the main idea, details, and vocabulary.  The reading section often includes single passages, double passages, and sentence completion questions.  It tests your ability to understand written English in a business context.  Time management is crucial in this section.'),
//     Content.text('input: When user provides a TOEIC sentence, ask for corrections or improvements.'),
//     Content.text('output: Sentence: \'Me and my colleague went to the meeting.\' Corrected: \'My colleague and I went to the meeting.\'  The pronoun \'me\' should be \'I\' in the subject position.  Another example: \'The report is more better than the previous one.\' Corrected: \'The report is better than the previous one.\'  Avoid using double comparatives.'),
//     Content.text('input: When user wants to improve their speaking skills, suggest techniques.'),
//     Content.text('output: Practice speaking with a language partner, record yourself, and use language learning apps for speaking exercises.  Other techniques include:  Shadowing native speakers, focusing on pronunciation, practicing core phrases, and participating in conversations.  For example, record yourself reading a passage and then compare it to a native speaker\'s recording.'),
//     Content.text('input: When user asks about time management during the TOEIC test, give tips.'),
//     Content.text('output: Advise to read instructions carefully, allocate time per section, and practice with timed mock tests.  A good strategy is to divide the total time by the number of questions in each section.  It\'s also important to practice pacing yourself so you don\'t spend too much time on any one question.  If you\'re unsure of an answer, it\'s often better to make an educated guess than to leave it blank.'),
//     Content.text('input: When user gives a phrase, ask for its use in a business context.'),
//     Content.text('output: Phrase: \'Circle back\'. Business context: \'Let\'s circle back on this topic at our next meeting.\'  In this context, \'circle back\' means to revisit or discuss something again later.  Another example: Phrase: \'On the same page\'. Business context: \'We need to make sure we\'re all on the same page regarding the project timeline.\'  Here, \'on the same page\' means to be in agreement or have the same understanding.'),
//     Content.text('input: When user asks about the TOEIC Writing test, describe its format and scoring.'),
//     Content.text('output: The TOEIC Writing test consists of eight tasks: two sentence completion tasks, two picture description tasks, and four opinion essay tasks.  The sentence completion tasks assess grammar and vocabulary, the picture description tasks evaluate the ability to describe visual information, and the opinion essay tasks measure the ability to express and support an opinion in writing.  Each section is scored separately, and the total score ranges from 0 to 200.  The writing test assesses clarity, coherence, grammar, vocabulary, and organization.'),
//     Content.text('input: When user asks about the TOEIC Speaking test, describe its format and scoring.'),
//     Content.text('output: The TOEIC Speaking test includes eleven tasks: two read aloud tasks, one picture description task, three response to questions tasks, and five propose a solution tasks. The read aloud tasks assess pronunciation and fluency, the picture description task evaluates the ability to describe visual information, the response to questions tasks measure the ability to provide relevant and coherent answers, and the propose a solution tasks measure the ability to offer solutions to problems. Each section is scored separately, and the total score ranges from 0 to 200. The speaking test assesses pronunciation, intonation, fluency, vocabulary, grammar, and coherence.'),
//     Content.text('input: When user asks for tips on improving vocabulary for the TOEIC, provide suggestions.'),
//     Content.text('output: Recommend learning root words, prefixes, and suffixes, using flashcards, reading English articles and books, and using vocabulary learning apps.  Focus on learning words in context, rather than memorizing lists of words.  For example, when you encounter a new word, try to guess its meaning from the surrounding words and then look it up in a dictionary.  Also, try to use new words in your own writing and speaking to reinforce your learning.'),
//     Content.text('input: When user asks about how to prepare for the TOEIC Listening Part 1 (Photographs), provide tips.'),
//     Content.text('output: Focus on identifying the main subject and action in the photograph.  Listen carefully to the descriptions and pay attention to details.  Practice identifying core vocabulary related to workplace settings and activities.  For example, if you see a photograph of someone working at a computer, you might expect to hear words like \'typing\', \'keyboard\', \'monitor\', \'office\', or \'desk\'.'),
//     Content.text('input: When user asks about how to prepare for the TOEIC Listening Part 2 (Question-Response), provide tips.'),
//     Content.text('output: Practice identifying different question types (e.g., who, what, where, when, why, how).  Pay attention to the intonation of the speaker, as this can often give clues about the type of question being asked.  Focus on understanding the key words in the question and response.  Practice anticipating possible responses.  For example, if you hear a question like \'When will the meeting start?\', you might expect to hear a response that includes a time or date.'),
//     Content.text('input: When user asks about how to prepare for the TOEIC Listening Part 3 (Short Conversations), provide tips.'),
//     Content.text('output: Read the questions before listening to the conversation.  This will help you focus on the information that is relevant to the questions.  Pay attention to the relationship between the speakers and the context of the conversation.  Take notes on key information.  Practice identifying the main idea and supporting details of the conversation.  For example, try to'),
//     Content.text('input: Gymmer meaning ? '),
//     Content.text('output: '),
//   ]);
//   print(response.text);
// }