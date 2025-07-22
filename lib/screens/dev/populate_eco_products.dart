import 'package:cloud_firestore/cloud_firestore.dart';

class EcoProductSeeder {
  final List<Map<String, dynamic>> ecoProducts = [
    {
      "name": "Reusable Water Bottle",
      "description":
          "A reusable water bottle is one of the simplest yet most impactful swaps you can make toward a more sustainable lifestyle. Designed to replace single-use plastic bottles, reusable bottles are typically made from durable, high-quality materials like stainless steel, glass, or BPA-free plastics. These materials ensure the bottle can withstand frequent use without degrading or leaching harmful chemicals into your beverage, making them a healthier choice for both you and the environment.By switching to a reusable water bottle, individuals can drastically cut down on the number of disposable plastic bottles they consume—an item that often ends up littering landfills, waterways, and oceans, where it takes hundreds of years to decompose. The environmental footprint of producing and disposing of single-use plastic bottles is enormous, involving fossil fuels, greenhouse gas emissions, and long-term pollution.In contrast, reusable bottles are built for longevity. Whether you’re at home, commuting, working out, or traveling, they provide a reliable and cost-effective hydration solution. Many come with insulation features to keep drinks hot or cold for extended periods, encouraging healthier hydration habits throughout the day. Over time, using a reusable bottle not only saves money but also supports the broader movement toward reducing plastic waste and protecting our planet’s ecosystems.Making the switch is a small, personal choice that collectively contributes to a cleaner, greener world.",
      "category": "Daily Use",
      "advantages": [
        "Reduces plastic waste",
        "Cost-effective in the long term",
        "Available in BPA-free materials",
      ],
      "nonEcoAlternatives": ["Plastic water bottles", "Disposable juice cartons"],
      "whyAvoidNonEcoAlternatives":
          "Plastic water bottles and juice cartons contribute significantly to global plastic pollution. They often end up in oceans or landfills, taking hundreds of years to decompose and harming marine life.",
      "imageUrl":
          "https://imgs.search.brave.com/eDV7zxh_8tOBQBRZXDHlXSFJGBTQMfwCGfdRRBT877s/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90aHVt/YnMuZHJlYW1zdGlt/ZS5jb20vYi9jb2xv/cmZ1bC1yZXVzYWJs/ZS13YXRlci1ib3R0/bGVzLWNvbnRhaW5l/cnMtd29vZGVuLXRh/YmxlLWdyZWVuLXBs/YW50LTM4MDYwNjM1/Mi5qcGc",
    },
    {
      "name": "Paper Bags",
      "description":
          "Paper bags are an environmentally conscious alternative to plastic bags, offering both biodegradability and the use of renewable resources. Unlike plastic bags, which can take hundreds of years to break down and often persist in landfills or pollute natural environments, paper bags decompose relatively quickly and do not release toxic chemicals into the soil or water during the process.Most paper bags are made from recycled or post-consumer paper, reducing the need for virgin materials and lowering the overall environmental impact of their production. They are also recyclable and compostable, which means they can either be reused in the paper production cycle or safely returned to the earth without causing harm.In addition to their ecological benefits, paper bags are sturdy, versatile, and suitable for a wide range of uses — from grocery shopping to gift wrapping and food packaging. Many retailers and consumers prefer them not only for their functionality but also for their clean and natural aesthetic. Choosing paper bags over plastic helps reduce the demand for petroleum-based products, supports the recycling industry, and contributes to a circular economy that values sustainability over disposability.",
      "category": "Shopping",
      "advantages": [
        "Biodegradable",
        "Reusable and recyclable",
        "Less harmful than plastic",
      ],
      "nonEcoAlternatives": ["Plastic bags", "Synthetic totes"],
      "whyAvoidNonEcoAlternatives":
          "Plastic bags take centuries to decompose and often clog waterways or harm wildlife. Synthetic totes are made from non-renewable petrochemicals and are not biodegradable.",
      "imageUrl":
          "https://plus.unsplash.com/premium_photo-1661636119130-0427b15cf821?w=500&auto=format&fit=crop&q=60",
    },
    {
      "name": "Bamboo Toothbrush",
      "description":
          "A bamboo toothbrush is a sustainable and environmentally friendly alternative to traditional plastic toothbrushes, which contribute significantly to global plastic pollution. The handle of a bamboo toothbrush is crafted from fast-growing, renewable bamboo, making it fully biodegradable and compostable under the right conditions. Unlike plastic toothbrushes that can take hundreds of years to break down and often end up in landfills or oceans, bamboo naturally decomposes without releasing harmful chemicals into the environment.Bamboo is not only biodegradable but also naturally antibacterial and antifungal, which makes it a hygienic option for oral care. By choosing a bamboo toothbrush, individuals can significantly reduce their plastic footprint, especially considering that billions of plastic toothbrushes are thrown away each year worldwide. These toothbrushes often end up as microplastics, polluting ecosystems and harming marine and terrestrial wildlife.Switching to a bamboo toothbrush is a small yet impactful change that supports a more sustainable lifestyle. It aligns with conscious consumerism, reduces demand for petroleum-based products, and promotes the use of natural, Earth-friendly resources in everyday personal care routines.",
      "category": "Personal Care",
      "advantages": [
        "100% biodegradable handle",
        "Natural and antibacterial",
        "Plastic-free",
      ],
      "nonEcoAlternatives": ["Plastic toothbrush", "Electric toothbrush"],
      "whyAvoidNonEcoAlternatives":
          "Plastic toothbrushes are not recyclable and millions are discarded every year, polluting the environment. Electric toothbrushes often require batteries and plastics that are not biodegradable.",
      "imageUrl":
          "https://images.unsplash.com/photo-1592372554345-22ced975691d?w=500&auto=format&fit=crop&q=60",
    },
    {
      "name": "Solar-Powered Lights",
      "description":
          "Solar-powered lights use energy from the sun to illuminate spaces, reducing the need for electricity. They are ideal for outdoor lighting and cut down on energy bills while lowering your carbon footprint.",
      "category": "Home & Living",
      "advantages": [
        "No electricity needed",
        "Reduces carbon footprint",
        "Cost-effective energy use",
      ],
      "nonEcoAlternatives": ["Electric bulbs", "Battery-powered lights"],
      "whyAvoidNonEcoAlternatives":
          "Electric and battery-powered lights rely on fossil fuel-generated power or disposable batteries, both of which increase greenhouse gas emissions and environmental waste.",
      "imageUrl":
          "https://plus.unsplash.com/premium_photo-1679815130906-86ca0af700a5?w=500&auto=format&fit=crop&q=60",
    },
    {
      "name": "Compostable Food Containers",
      "description":
          "Compostable food containers offer an eco-conscious alternative to traditional plastic or Styrofoam packaging. Made from plant-based materials such as cornstarch, sugarcane bagasse (fiber left after extracting juice), or wheat bran, these containers are designed to break down naturally in composting environments—often within just a few weeks under the right conditions. This means they don’t linger in landfills or pollute oceans like conventional food packaging does.These containers are ideal for takeout meals, food storage, catering events, and picnics. Not only are they sturdy and leak-resistant, but they are also free from petroleum-based plastics and synthetic coatings, making them safer for both human health and the environment. Since they are compostable at home or in industrial composting facilities, they return valuable nutrients back to the soil rather than contributing to the growing global waste crisis.In contrast to materials like Styrofoam, which can take up to 500 years to degrade and often leach harmful chemicals into food and the environment, compostable containers decompose quickly without releasing toxins. Choosing them helps reduce your carbon footprint, supports sustainable agricultural byproducts, and promotes a circular system where waste becomes a resource instead of pollution.Switching to compostable food containers is a practical step toward greener living—especially in the food service industry where packaging waste is a significant issue.",
      "category": "Kitchen",
      "advantages": [
        "Made from renewable resources",
        "Compostable in home compost",
        "Plastic-free",
      ],
      "nonEcoAlternatives": ["Styrofoam boxes", "Plastic Tupperware"],
      "whyAvoidNonEcoAlternatives":
          "Styrofoam and plastic containers persist in landfills for centuries and release harmful chemicals when broken down. They’re also non-compostable and toxic when burned.",
      "imageUrl":
          "https://images.unsplash.com/photo-1752051665095-be37be749e55?w=500&auto=format&fit=crop&q=60",
    },
    {
      "name": "Cloth Napkins",
      "description":
          "Cloth napkins are a sustainable, stylish, and cost-effective alternative to disposable paper napkins and wet wipes. Made from durable fabrics such as cotton, linen, or bamboo, they are designed to be washed and reused multiple times—making them an eco-friendly choice for everyday use as well as special occasions. Unlike single-use paper products, which require continuous consumption of resources and generate large amounts of waste, cloth napkins offer a reusable solution that significantly reduces environmental impact over time.In addition to their practicality, cloth napkins bring a sense of elegance and intention to meals. Whether you're hosting a dinner party, packing a lunchbox, or setting the family table, they add a touch of refinement and warmth that disposables simply can't match. They’re also available in a wide variety of colors, patterns, and textures, allowing for personalization and style that aligns with your home or event aesthetic.Economically, investing in cloth napkins pays off in the long run. While the initial cost may be higher than a pack of paper napkins, their reusability leads to significant savings over time—not to mention the reduced frequency of trips to the store and less clutter in your trash bin. They're machine washable and can often be used for years without losing quality.Choosing cloth napkins is a simple, effective way to reduce household waste, conserve natural resources, and support a zero-waste lifestyle. It's a small change with a lasting positive impact on both your home and the planet.",
      "category": "Home & Living",
      "advantages": [
        "Reusable for years",
        "Reduces paper waste",
        "Adds elegance to meals",
      ],
      "nonEcoAlternatives": ["Paper napkins", "Wet wipes"],
      "whyAvoidNonEcoAlternatives":
          "Paper napkins are made from trees and are often single-use. Wet wipes are plastic-based and clog sewage systems while adding to non-biodegradable waste.",
      "imageUrl":
          "https://images.unsplash.com/photo-1591130901966-1b6770de5120?w=500&auto=format&fit=crop&q=60",
    },
    {
      "name": "Organic Cotton Tote Bag",
      "description":
          "Organic cotton tote bags are a practical and eco-conscious alternative to single-use plastic and coated paper bags. Crafted from certified organic cotton, these totes are grown without the use of synthetic pesticides, herbicides, or genetically modified seeds—making them safer for the environment, farm workers, and end consumers. The farming process also uses significantly less water and promotes soil health through natural cultivation methods, reducing the ecological footprint of the product from the very beginning.These bags are built for durability and everyday functionality. Their strong stitching and breathable fabric allow them to carry groceries, books, clothing, and personal items with ease. Unlike disposable bags that tear easily and require constant replacement, an organic cotton tote can be reused hundreds of times, making it a long-lasting and sustainable investment. Many feature wide handles, pockets, and foldable designs, adding to their convenience and versatility for shopping, travel, or everyday errands.Beyond functionality, organic cotton totes also serve as a symbol of sustainable living. They reflect a commitment to reducing waste, conserving resources, and avoiding petroleum-based plastics that pollute our land and oceans. Even paper bags, though biodegradable, often require large amounts of water and energy to produce—especially when coated or reinforced. By contrast, a single organic cotton tote can eliminate the need for hundreds of disposable alternatives over its lifetime.Choosing an organic cotton tote bag is more than a shopping habit—it's a statement in favor of mindful consumption and environmental stewardship. Stylish, reusable, and chemical-free, it’s a small switch that contributes to a cleaner planet and a more sustainable future.",
      "category": "Shopping",
      "advantages": [
        "Organic and chemical-free",
        "Reusable for years",
        "Replaces single-use bags",
      ],
      "nonEcoAlternatives": ["Plastic grocery bags", "Paper bags with coating"],
      "whyAvoidNonEcoAlternatives":
          "Plastic grocery bags pollute land and sea, while coated paper bags cannot be recycled due to their waterproof layers and are often treated with chemicals.",
      "imageUrl":
          "https://images.unsplash.com/photo-1621357366416-3e754e1a3d8b?w=500&auto=format&fit=crop&q=60",
    },
    {
      "name": "LED Bulbs",
      "description":
          "LED (Light Emitting Diode) bulbs are a highly energy-efficient and environmentally friendly alternative to traditional incandescent and halogen bulbs. They use significantly less electricity—up to 80% less—while providing the same or better quality of light, which helps to reduce overall energy consumption and lower electricity bills. This efficiency not only saves money but also reduces the demand on power plants, thereby decreasing greenhouse gas emissions and your carbon footprint.One of the major advantages of LED bulbs is their exceptional lifespan. They can last up to 25,000 to 50,000 hours, which is several times longer than incandescent bulbs and even longer than compact fluorescent lights (CFLs). This longevity means fewer replacements, reducing waste and the environmental impact associated with manufacturing, shipping, and disposal of bulbs.In addition to efficiency and durability, LED bulbs produce very little heat compared to traditional lighting options, making them safer to handle and reducing the risk of burns or fire hazards. Their lower heat output also contributes to reduced cooling costs in homes and offices, especially in warmer climates.LEDs are available in a variety of colors and brightness levels, allowing for versatile lighting solutions in any setting—from cozy homes to large commercial spaces. They turn on instantly without warm-up time and are compatible with many dimmer switches, providing better control over lighting ambiance.By switching to LED bulbs, you’re making a positive impact on the environment by conserving energy, reducing waste, and minimizing harmful emissions, all while enjoying cost savings and safer lighting.",
      "category": "Electronics",
      "advantages": [
        "Consumes less power",
        "Long-lasting",
        "Lower electricity bills",
      ],
      "nonEcoAlternatives": ["Incandescent bulbs", "Halogen bulbs"],
      "whyAvoidNonEcoAlternatives":
          "Incandescent and halogen bulbs consume more electricity and generate excessive heat. They have shorter lifespans and increase energy demand from non-renewable sources.",
      "imageUrl":
          "https://imgs.search.brave.com/KqNcEk8A-MrKKadtQFMrn4L-XJqMXRgWMm5FXoAo7xE/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTE0/Mzc0OTA2My9waG90/by9sZWQtYnVsYnMt...",
    },
    {
      "name": "Biodegradable Cleaning Sponges",
      "description":
          "Biodegradable cleaning sponges are made from natural, plant-based materials such as cellulose, coconut fiber, or other sustainable fibers. Unlike conventional synthetic sponges, which are often made from plastic-based foams that contribute to microplastic pollution, these eco-friendly sponges are fully compostable and break down naturally in the environment without leaving harmful residues.These sponges offer effective cleaning power comparable to traditional options, able to tackle dishes, countertops, and other household surfaces with ease. Their natural fibers are gentle enough to avoid scratching delicate surfaces while still being durable for everyday use.Because they are made from renewable resources, biodegradable sponges help reduce reliance on fossil fuels and decrease the volume of non-recyclable waste sent to landfills. After their useful life, these sponges can be composted in home compost bins or industrial compost facilities, returning valuable organic matter to the soil.Using biodegradable cleaning sponges supports a healthier planet by minimizing plastic pollution in waterways and ecosystems, reducing chemical toxins, and promoting sustainable consumption habits. They are safe for your family, pets, and the environment—making the simple switch from synthetic sponges a powerful step toward greener living.",
      "category": "Cleaning",
      "advantages": [
        "Biodegradable and compostable",
        "Non-toxic materials",
        "Safe for the environment",
      ],
      "nonEcoAlternatives": ["Plastic scouring pads", "Synthetic foam sponges"],
      "whyAvoidNonEcoAlternatives":
          "Plastic and synthetic sponges shed microplastics during use and do not decompose, adding to landfill and water pollution.",
      "imageUrl":
          "https://imgs.search.brave.com/WdWTfGDmZCjkp7q91WkmriuhJc83eekHJmdXig5MfRY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL0kv/NzFZdHpwVngyMEwu/anBn",
    },
    {
      "name": "Eco-Friendly Detergent",
      "description":
          "Eco-friendly detergents are formulated using plant-based, biodegradable ingredients that effectively clean clothes while being gentle on the environment. Unlike conventional detergents, which often contain harsh chemicals, phosphates, and synthetic fragrances, eco detergents avoid harmful substances that can pollute rivers, lakes, and oceans, damaging aquatic ecosystems and harming marine life.These detergents break down naturally after use, preventing the buildup of toxic residues in water systems. They are free from artificial dyes, sulfates, and parabens, making them a safer choice for individuals with sensitive skin, allergies, or chemical sensitivities.Using eco-friendly detergent not only helps reduce your household’s environmental footprint but also promotes a healthier home environment by minimizing exposure to potentially harmful chemicals. They clean effectively at lower temperatures, saving energy and reducing carbon emissions associated with heating water.By switching to biodegradable, plant-based detergents, you contribute to the conservation of water quality and support sustainable manufacturing practices. This small change can have a big impact on protecting both human health and the planet’s delicate ecosystems.",
      "category": "Cleaning",
      "advantages": [
        "Biodegradable ingredients",
        "Non-toxic to marine life",
        "No synthetic fragrances",
      ],
      "nonEcoAlternatives": ["Chemical detergents", "Bleach-heavy liquids"],
      "whyAvoidNonEcoAlternatives":
          "Conventional detergents contain phosphates, surfactants, and synthetic fragrances that harm aquatic ecosystems and cause skin irritations. Bleach-based liquids release toxic fumes.",
      "imageUrl":
          "https://imgs.search.brave.com/0y1P8fIgEP2kFfNNLhFmmTXWL6AQe2KAF70ABoio5To/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMuc3F1YXJlc3Bh/Y2UtY2RuLmNvbS9j/b250ZW50L3YxLzVi/YjhjZDVhYTA5YTdl/NGM4MGNiOWZkOC80/NjE4Mjk0NS0zZDFi/LTQxYTktYWVjYi0x/Zjc1MWNjZTBiOTIv/ZWNvK2ZyaWVuZGx5/K2xhdW5kcnkrZGV0/ZXJnZW50KygxOSku/anBn",
    },
  ];

  Future<void> seedDatabase() async {
    final collection = FirebaseFirestore.instance.collection('eco_friendly_products');

    final snapshot = await collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print("✅ Products already seeded. Skipping seeding.");
      return;
    }

    for (var product in ecoProducts) {
      await collection.add(product);
    }

    print("✅ Eco-friendly products added to Firestore.");
  }
}
