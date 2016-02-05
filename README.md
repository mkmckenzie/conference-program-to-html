# conference-program-to-html

##Background:
We used to have 3 seperate conferences spread out over the spring: the Landfill Symposium, the Landfill Gas & Biogas Symposium, and he Road to Zero Waste Conference. In 2014, we co-located these three conferences, and added on the U.S. E.P.A.'s Landfill Methane Outreach Program.  In 2015, Fleet Management Expo added their conference to our roster. We now have these 5 events, plus our Spring Training Center, under the umbrella of the aptly named "SWANApalooza".

##The Problem:
We are responsible for the programming for the first three conferences. Each conference has it's own sessions, but there are also sessions that are shared between all the conferences, such as the keynotes and awards sessions. Each conference has it's own website with it's own schedule, but there is also the SWANApalooza "Master" conference program that includes all of these. Last year, I was faced with the issue of creating and updating the conference sessions in as many as 4 places. This was incredibly time consuming.

##My Solution:
I built a small Ruby script that takes a unified CSV file of all the sessions with their information and outputs it as an HTML table. The script formats the table with appropriate class names based on the information given in the CSV file. I can place the output on the main SWANApalooza page, and use the capabilities of our CMS (DNN) to syndicate the program across the Landfill Symposium, Landfil Gas & Biogas Symposium, and Road to Zero Conference pages. I only have to update the session list in one place, and then update the HTML in one place as well. To make sure that only relevant sessions appear on the individual conference pages, I have hidden rows tagged with non-relevant conferences. I did this by taking advantage of the CSS hierarchy and inserting this information in the style tags on each page. All pages share the same external CSS stylesheet.

##Future Improvements:
- Take out hard-coded dates so that it works for any conference throughout the year (we have 3 more slated for 2016)
- Move from table to divs, and more stylized
- Move it to a rails app so staff can input sessions into form directly, eliminating the inputting step for me



