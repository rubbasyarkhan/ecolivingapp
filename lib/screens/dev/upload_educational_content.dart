import 'package:cloud_firestore/cloud_firestore.dart';

class EducationalContentSeeder {
  final List<Map<String, dynamic>> contents = [
    {
      "title": "Understanding Climate Change: A Beginner's Guide",
      "type": "video",
      "description":
          "This video breaks down the science behind climate change, its causes, and its potential impacts on our planet. Learn how greenhouse gases affect global temperatures, how human activities like deforestation and fossil fuel use accelerate the process, and what steps we can take to slow it down. Ideal for students and eco-curious individuals who want a foundational understanding of climate science.",
      "contentUrl": "https://www.youtube.com/watch?v=G4H1N_yXBiA",
      "thumbnail": "https://img.youtube.com/vi/G4H1N_yXBiA/maxresdefault.jpg",
      "category": "videos"
    },
    {
      "title": "10 Easy Ways to Reduce Plastic Waste at Home",
      "type": "article",
      "description":
          "Plastic pollution is one of the biggest threats to our environment. This article outlines ten simple and effective ways you can reduce your plastic usage on a daily basis—from switching to reusable bags and bottles to avoiding single-use plastics entirely. Full of actionable tips and product alternatives.",
      "contentUrl": "https://www.greenmatters.com/p/reduce-plastic-waste-tips",
      "thumbnail": "https://images.unsplash.com/photo-1581574202413-dfd31499f098",
      "category": "articles"
    },
    {
      "title": "Solar Power vs Fossil Fuels: Which is More Sustainable?",
      "type": "infographic",
      "description":
          "This infographic compares solar energy and fossil fuels across key sustainability metrics: carbon emissions, costs over time, environmental impact, and resource availability. Ideal for quick understanding of how renewable energy sources stack up against traditional power generation methods.",
      "contentUrl":
          "https://images.squarespace-cdn.com/content/v1/5e01c2fc53f2b62281f4a987/infographic-solar-vs-fossil.png",
      "thumbnail": "https://images.unsplash.com/photo-1509395062183-67c5ad6faff9",
      "category": "infographics"
    },
    {
      "title": "What is a Circular Economy?",
      "type": "video",
      "description":
          "This educational video explains the concept of a circular economy—an alternative to the traditional linear model of take-make-waste. Learn how materials and products are reused, repaired, and recycled to minimize waste and extend resource lifecycles. Features real-world examples of companies and communities embracing circular practices.",
      "contentUrl": "https://www.youtube.com/watch?v=zCRKvDyyHmI",
      "thumbnail": "https://img.youtube.com/vi/zCRKvDyyHmI/maxresdefault.jpg",
      "category": "videos"
    },
    {
      "title": "Top 5 Eco-Friendly Products to Try in 2024",
      "type": "article",
      "description":
          "Discover five innovative and sustainable products that can help reduce your environmental footprint this year. From biodegradable cleaning supplies to reusable kitchen essentials, this guide features eco-friendly swaps that are good for you and the planet. Includes product links and tips for responsible consumption.",
      "contentUrl":
          "https://www.ecowarriorprincess.net/2024/01/eco-friendly-products-2024/",
      "thumbnail": "https://images.unsplash.com/photo-1616627981174-fb06bd0eec87",
      "category": "articles"
    },
  ];

  Future<void> seedDatabase() async {
    final collection = FirebaseFirestore.instance.collection('educational_contents');

    final snapshot = await collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print("✅ Educational content already seeded. Skipping seeding.");
      return;
    }

    final now = Timestamp.now();

    for (var content in contents) {
      await collection.add({
        ...content,
        'publishedAt': now, // add timestamp
      });
    }

    print("✅ Educational content added to Firestore with publishedAt field.");
  }
}
