import requests
from bs4 import BeautifulSoup
import re
from urllib.parse import urljoin
from datetime import datetime
from typing import List
import json

class Session:
    def __init__(self, date_time, name, abstract, session_type, audience_level, audiences, description, primary_topic, secondary_topics, presenters, location, url):
        self.date_time = date_time
        self.name = name
        self.abstract = abstract
        self.session_type = session_type
        self.audience_level = audience_level
        self.audiences = audiences
        self.description = description
        self.primary_topic = primary_topic
        self.secondary_topics = secondary_topics
        self.presenters = presenters
        self.location = location
        self.url = url

    def __repr__(self):
        return f"Session({self.name})"

    def __str__(self):
        return f"Session {self.name} on {self.date_time.strftime('%A, %B %d, %Y %I:%M %p')}"

    def to_dict(self):
        return {
            "date_time": self.date_time.isoformat(),
            "name": self.name,
            "abstract": self.abstract,
            "session_type": self.session_type,
            "audience_level": self.audience_level,
            "audiences": self.audiences,
            "description": self.description,
            "primary_topic": self.primary_topic,
            "secondary_topics": self.secondary_topics,
            "presenters": self.presenters,
            "location": self.location,
            "url": self.url,
        }

    def to_json(self):
        return json.dumps(self.to_dict(), indent=2, separators=(",", ": "))

    def print(self):
        # Print out the data for this event
        print("Date and Time:", self.day_time.strftime("%A, %B %d, %Y %I:%M %p"))
        print("Session Name:", self.session_name)
        print("Abstract:", self.abstract)
        print("Session Type:", self.session_type)
        print("Audience Level:", self.audience_level)
        print("Audiences:", self.audiences)
        print("Description:", self.description)
        print("Primary Topic:", self.primary_topic)
        print("Secondary Topics:", self.secondary_topics)
        for presenter in self.presenters:
            print("Presenter Name:", presenter["name"])
            print("Presenter Organization:", presenter["organization"])
        print("Location:", self.location)
        print("URL:", self.url)


# Create a list to store the Session objects
sessions: List[Session] = []

# Make a request to the index page
url = "https://www.csun.edu/cod/conference/sessions/index.php/public/conf_sessions/index_by_day/day:all"
response = requests.get(url)

# Parse the HTML with BeautifulSoup
soup = BeautifulSoup(response.text, "html.parser")

# Find all the tables on the page
tables = soup.find_all("table")

session_count = 0

# Loop through the tables
for table in tables:
    # Find the day and time for this table
    day_str = table.find_previous_sibling("h2", {"class": "day"}).text.strip()
    time_str = table.find_previous_sibling("h3").text.strip()

    # Strip the time zone abbreviation from the time string
    time_str = re.sub(r"\b\w{3}\b", "", time_str).strip()

    # Combine the day and time into a datetime object
    day_time_str = f"{day_str} {time_str}"
    day_time = datetime.strptime(day_time_str, "%A, %B %d, %Y %I:%M %p")

    # Loop through the rows in the table
    rows = table.find_all("tr")[1:]
    for row in rows:
        # Get the session name and link to the detail page
        session_link = row.find("a")
        session_name = session_link.text.strip()
        session_url = urljoin(url, session_link["href"])

        # Make a request to the detail page
        session_response = requests.get(session_url)

        # Parse the HTML with BeautifulSoup
        session_soup = BeautifulSoup(session_response.text, "html.parser")

        # Find the presenters
        presenter_h2 = session_soup.find("h2", string=re.compile("Presenter[s]?"))
        presenter_list = presenter_h2.find_next_sibling("ul").find_all("li")
        presenters = []
        for presenter in presenter_list:
            name = presenter.contents[0].strip()
            organization = presenter.contents[2].strip() if len(presenter.contents) > 2 else None
            presenters.append({"name": name, "organization": organization})

        # Find the audiences
        audience_list = session_soup.find("dt", string="Audience").find_next_sibling("dd").find_all("li")
        audiences = [audience.text.strip() for audience in audience_list]

        # Find the session type, audience level, and description
        session_type = session_soup.find("dt", string="Session Type").find_next_sibling("dd").text.strip()
        audience_level = session_soup.find("dt", string="Audience Level").find_next_sibling("dd").text.strip()
        description = session_soup.find("dt", string="Description").find_next_sibling("dd").text.strip()

        # Find the session summary (abstract), primary topic, and secondary topics
        abstract_pattern = re.compile("Summary|Abstract")
        abstract_dt = session_soup.find("dt", string=abstract_pattern)
        abstract_dd = abstract_dt.find_next_sibling("dd") if abstract_dt else None
        abstract = abstract_dd.text.strip() if abstract_dd else None
        primary_topic = session_soup.find("dt", string="Primary Topic").find_next_sibling("dd").text.strip()
        secondary_topic_list = session_soup.find("dt", string="Secondary Topics").find_next_sibling("dd").find_all("li")
        secondary_topics = [topic.string.strip() for topic in secondary_topic_list]

        # Get the location from the current row
        location = row.find_all("td")[2].text.strip()

        # Create a new Session object
        session = Session(
            date_time=day_time,
            name=session_name,
            abstract=abstract,
            session_type=session_type,
            audience_level=audience_level,
            audiences=audiences,
            description=description,
            primary_topic=primary_topic,
            secondary_topics=secondary_topics,
            presenters=presenters,
            location=location,
            url=session_url,
        )

        # Add the new Session object to the sessions list
        print('---------------------------')
        print(session.to_json())
        sessions.append(session)
        print(f"Session #{session_count + 1}")
        session_count += 1

print('================================================')
json_str = json.dumps(sessions, default=lambda o: o.to_dict(), indent=2, separators=(",", ": "))

print(json_str)

# Open a file for writing
with open("sessions.json", "w") as f:
    # Write the JSON string to the file
    f.write(json_str)

print(f"{len(sessions)} Sessions saved to sessions.json")
