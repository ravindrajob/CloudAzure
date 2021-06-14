## Show expired apps registrations
Azure do not have a native feature to report on expiring App registrations. The purprose of azure is to provide an automated mechanism of calculating and ingesting the expiration dates into Log Analytics and automatically notify resources when expiration is within threshold.

## 1. Create and run the RunBook
See the ApplicationsRegistrations.ps1

## 2. Check the result in logs analytics
![alt text](https://ravindrajob.blob.core.windows.net/assets/widget3.png)

## 3. Create a schedule
![alt text](https://ravindrajob.blob.core.windows.net/assets/hourly-apps.png)

## 4. Check the result
### The query show the last 25 expirations
```sql
NameOfAppsRegistration_CL
| where isnotempty(timestampunix_s)
| project TimeGenerated, DisplayName_s, EndDate_s, StartDate_s, timestampunix_s, datetime_diff('Day', todatetime(EndDate_s), now())
| project-rename Remaining_Days = Column1
| summarize arg_max(TimeGenerated, *) by DisplayName_s
| order by todatetime(EndDate_s) asc
| take 25
```
## 5. Display the result in grafana
![alt text](https://ravindrajob.blob.core.windows.net/assets/widget2.png)
#### Tips to show correctly days in grafana widget:
![alt text](https://ravindrajob.blob.core.windows.net/assets/grafana-appsregistration.png)