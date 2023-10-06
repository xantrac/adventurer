import Adventurer.Factory

user =
  insert(:user, email: "dellolio.marco@gmail.com")
  |> set_password("password")

story =
  insert(:story,
    title: "The Story of the Adventurer",
    description:
      "Welcome to \"Lost in the Labyrinth of Shadows.\" In this gripping adventure game book, you become Alex, an intrepid archaeologist, drawn into a web of mystery on the secretive island of Veridia. Your choices will determine your fate as you navigate lush jungles, decipher cryptic riddles, and confront ancient enigmas. The island's untold secrets lie before you; will you uncover them, or become lost in the labyrinth of shadows?

Prepare to embark on a journey where your decisions shape the story. Dive into the heart of Veridia, a place teeming with hidden dangers and forgotten history. The outcome is in your hands as you turn the pages and begin your quest for adventure and enlightenment.",
    user: user,
    starting_node_id: nil,
    published_at: DateTime.utc_now(),
    cover_image_url: Adventurer.Clients.Unsplash.get_random_image("adventure")
  )

seventh_node =
  insert(:node,
    title: "Happy Ending",
    story: story,
    body:
      generate_node_body([
        "You decide to follow the path that leads uphill, hoping to gain a vantage point and get a better view of your surroundings. The path gradually ascends, winding through the lush jungle. Your heart races with each step, and anticipation fills the air.",
        "After a challenging climb, you reach a high point that overlooks the island. From here, you can see the vast expanse of the jungle, the beach you washed ashore on, and even a distant, sparkling coastline. The sight of the coastline fills you with hope, as it suggests that there might be a way off this mysterious island.",
        "You carefully make your way down the hill, energized by the prospect of rescue. As you approach the beach, you notice a small boat washed ashore. It appears to be in working condition, and you waste no time in launching it into the water.",
        "The boat takes you on a journey across the ocean, and after what feels like an eternity, you spot a passing ship. You frantically signal for help, and to your immense relief, the ship changes course to rescue you.",
        "Rescued at last, you return home with an incredible tale of survival and adventure, forever grateful for the twist of fate that led you to that high vantage point on the mysterious island."
      ])
  )

fourth_node =
  insert(:node,
    title: "The fifth node",
    story: story,
    body:
      generate_node_body([
        "With a sense of urgency, you decide to head towards the dense forest that lines the edge of the beach. The thick foliage engulfs you as you step beneath the tree canopy, and the sounds of the waves grow distant.",
        "As you venture deeper into the jungle, the air becomes humid and stifling. The tangled undergrowth makes your progress slow and arduous. You realize that you're running out of daylight, and the jungle takes on an eerie and unsettling atmosphere.",
        "Suddenly, you hear a rustling in the bushes ahead. Your heart races as you turn to face the source of the noise. Out of the dense underbrush emerges a group of hostile-looking natives, their faces painted with intricate patterns, and spears held menacingly in their hands.",
        "You try to communicate, but there is a language barrier, and your attempts at peace are met
        with hostility. Panic sets in as you realize there's no way to reason with them. The natives
        surround you, and you're left with no choice but to surrender.",
        "Your adventure on this mysterious island ends abruptly, and your fate remains unknown."
      ])
  )

sixth_node =
  insert(:node,
    title: "Poisonous snake",
    story: story,
    body:
      generate_node_body([
        "Ignoring the note's warning, you decide to search for signs of civilization or other survivors along the beach. As you stroll along the shore, a feeling of unease gnaws at you, and the setting sun casts long, ominous shadows.",
        "Just as you begin to lose hope of finding any clues, you come across a peculiar structure half-buried in the sand. It appears to be an ancient, weathered statue, its stone features twisted into a grotesque, nightmarish visage. As you approach it, you suddenly feel a searing pain in your chest.",
        "You look down to see a venomous snake sinking its fangs into your leg. Panic sets in as the poison courses through your veins, paralyzing you. The last thing you see is the sinister grin on the face of the stone statue as darkness envelops you.",
        "Your quest for answers ends in tragedy, and the island's secrets remain buried forever."
      ])
  )

third_node =
  insert(:node,
    title: "The final node",
    story: story,
    body:
      generate_node_body([
        "With a sense of determination, you decide to head towards the dense forest that lines the edge of the beach. The thick foliage engulfs you as you step beneath the tree canopy, and the sounds of the waves grow distant. You feel a sense of unease as you venture deeper into the unknown.",
        "As you explore further, the forest offers both challenges and opportunities. You discover various edible fruits and berries, which ease your hunger and provide sustenance. You also find a small stream where you can quench your thirst.",
        "After a few hours of navigating through the dense vegetation, you come across a fork in the path."
      ]),
    choices: [
      build(:choice,
        description:
          "Follow the path that leads uphill, hoping to gain a vantage point and get a better view of your surroundings",
        choice_targets: [
          build(:choice_target,
            target_node: seventh_node
          )
        ]
      ),
      build(:choice,
        description:
          "Continue deeper into the forest, searching for signs of shelter or civilization.",
        choice_targets: [
          build(:choice_target,
            target_node: sixth_node
          )
        ]
      )
    ]
  )

fifth_node =
  insert(:node,
    title: "Going home",
    story: story,
    body:
      generate_node_body([
        "With a mixture of curiosity and determination, you decide to follow the note's instructions and head into the jungle. Each step takes you further away from the familiar shore and deeper into the unknown. The forest canopy overhead filters the fading sunlight, creating a serene yet eerie ambiance.",
        "As you venture deeper into the jungle, you encounter various challenges: navigating through dense vegetation, foraging for food and water, and occasionally encountering peculiar wildlife. Along the way, you discover signs of a previous civilization that once inhabited this island. Abandoned huts and overgrown paths suggest that this place was once home to others who faced the same enigmatic circumstances.",
        "Days turn into weeks, and you continue to explore, your determination unwavering. Finally,
        you stumble upon a hidden clearing where you find a makeshift raft. With some repairs and
        improvisation, you manage to make it seaworthy. As you set sail, you spot a distant ship on
        the horizon, and you signal for help.",
        "Rescued at last, you return home with a newfound sense of adventure and resilience, forever changed by your extraordinary experience on the mysterious island."
      ])
  )

second_node =
  insert(:node,
    title: "Open the envelope",
    story: story,
    body:
      generate_node_body([
        "You carefully open the envelope, your fingers trembling slightly with anticipation. Inside,
        you find a single sheet of paper. It's a handwritten note, and the words on it catch your
        attention. The note reads, \"Follow the path into the jungle. You are not alone here. Trust
        no one.\"",
        "As you read the mysterious message, your heart quickens with a mixture of hope and apprehension.
The mention of a path into the jungle suggests that there might be a way off this island or, at the
very least, some answers about your situation. However, the warning to trust no one fills you with a
sense of unease.",
        "The sun is sinking lower on the horizon, and the island's landscape is bathed in the warm, fading
light. You stand at a crossroads, facing a pivotal decision. You can either follow the path into the
jungle or head back to the beach. What will you do?"
      ]),
    choices: [
      build(:choice,
        description:
          "Decide to follow the note's instructions and head into the jungle, determined to uncover the island's secrets.",
        choice_targets: [
          build(:choice_target,
            target_node: fifth_node
          )
        ]
      ),
      build(:choice,
        description:
          "Choose to disregard the note's advice and search for signs of civilization or other survivors along the beach",
        choice_targets: [
          build(:choice_target,
            target_node: sixth_node
          )
        ]
      )
    ]
  )

first_node =
  insert(:node,
    title: "The Beginning",
    story: story,
    body:
      generate_node_body([
        "You awaken to the soothing sound of gentle waves caressing the sandy shore of an unfamiliar island.
As your eyes flutter open, the sun is descending, painting the sky with hues of orange and pink.
It's a breathtaking sight, but your awe is quickly replaced by a sense of confusion. You have no
memory of how you got here or where \"here\" even is. The last thing you remember is going to bed in
your own comfortable room.",
        "Slowly, you push yourself up from the soft sand, the grains sticking to your clothes. With a
bewildered glance around, you take stock of your situation. Your attire is in disarray, and you
can't help but wonder how you ended up in this predicament. There are no familiar landmarks or
structures in sight, just the endless expanse of a deserted beach.",
        "Your fingers idly trace the outline of a small, sealed envelope tucked securely in your pocket.
It's the only item you seem to have with you aside from your clothes. The envelope feels strangely
important, a fragile link to a world you can't quite remember. As you retrieve it and hold it up to
the fading light, you notice that it bears no address, just your name written neatly on the front."
      ]),
    choices: [
      build(:choice,
        description: "Open the envelope to see if it contains any clues about your situation.",
        choice_targets: [
          build(:choice_target,
            target_node: second_node
          )
        ]
      ),
      build(:choice,
        description:
          "Stand up and survey your surroundings, hoping to find signs of civilization or a path leading inland",
        choice_targets: [
          build(:choice_target,
            target_node: third_node
          )
        ]
      ),
      build(:choice,
        description:
          "Decide to head towards the dense forest that lines the edge of the beach, hoping to find food, shelter, or some answers",
        choice_targets: [
          build(:choice_target,
            target_node: fourth_node
          )
        ]
      )
    ]
  )

Adventurer.Stories.update_story(story, %{start_node_id: first_node.id})
