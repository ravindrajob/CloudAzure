# Structure
<!-- </Sequence> -->
<!-- <Gantt> -->
<tr><td colspan=2 align="center">
    <b>Gantt</b><br />
    [<a href="http://mermaid-js.github.io/mermaid/#/gantt">docs</a> - <a href="https://mermaid-js.github.io/mermaid-live-editor/edit#eyJjb2RlIjoiZ3JhcGggVERcbkFbQ2hyaXN0bWFzXSAtLT58R2V0IG1vbmV5fCBCKEdvIHNob3BwaW5nKVxuQiAtLT4gQ3tMZXQgbWUgdGhpbmt9XG5DIC0tPnxPbmV8IERbTGFwdG9wXVxuQyAtLT58VHdvfCBFW2lQaG9uZV1cbkMgLS0-fFRocmVlfCBGW2ZhOmZhLWNhciBDYXJdXG4iLCJtZXJtYWlkIjoie1xuICBcInRoZW1lXCI6IFwiZGVmYXVsdFwiXG59IiwidXBkYXRlRWRpdG9yIjpmYWxzZSwiYXV0b1N5bmMiOnRydWUsInVwZGF0ZURpYWdyYW0iOmZhbHNlfQ">live editor</a>]
</td></tr>
<tr>
    <td><pre>
gantt
section Section
Completed :done,    des1, 2014-01-06,2014-01-08
Active        :active,  des2, 2014-01-07, 3d
Parallel 1   :         des3, after des1, 1d
Parallel 2   :         des4, after des1, 1d
Parallel 3   :         des5, after des3, 1d
Parallel 4   :         des6, after des4, 1d
    </pre></td>
    <td align="center">
        <img src="https://raw.githubusercontent.com/mermaid-js/mermaid/master/img/gray-gantt.png" />
    </td>
</tr>

## Dependencies

### Don't forget to add the OMSIngestionAPI librairy in your Az automation  : 
![alt text](https://ravindrajob.blob.core.windows.net/assets/LibrairyOMS.png)
