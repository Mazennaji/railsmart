require "pagy/extras/overflow"

Pagy::DEFAULT[:limit] = 6
Pagy::DEFAULT[:overflow] = :last_page