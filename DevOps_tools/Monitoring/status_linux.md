use nodeexporter data to make a beautiful dash board scripted is given below

```bash
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": null,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "datasource": {
        "type": "prometheus",
        "uid": "${datasource}"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "text"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "orange",
                "value": 50
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": [
          {
            "matcher": {
              "id": "byName",
              "options": "Run time"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-background"
                }
              },
              {
                "id": "unit",
                "value": "s"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "CPU Usage (%)"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-background"
                }
              },
              {
                "id": "unit",
                "value": "percent"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Memory Usage (%)"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-background"
                }
              },
              {
                "id": "unit",
                "value": "percent"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Root (/) Usage (%)"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-background"
                }
              },
              {
                "id": "unit",
                "value": "percent"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Root (/) Free"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-background"
                }
              },
              {
                "id": "unit",
                "value": "bytes"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "Data Free"
            },
            "properties": [
              {
                "id": "custom.cellOptions",
                "value": {
                  "type": "color-background"
                }
              },
              {
                "id": "unit",
                "value": "bytes"
              }
            ]
          },
          {
            "matcher": {
              "id": "byName",
              "options": "CPU Frequency"
            },
            "properties": [
              {
                "id": "unit",
                "value": "hertz"
              }
            ]
          }
        ]
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 1,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": []
      },
      "title": "Server Resource Overview (Linux)",
      "transformations": [
        {
          "id": "joinByField",
          "options": {
            "byField": "instance",
            "mode": "outer"
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Time": true,
              "Time 1": true,
              "Time 2": true,
              "Time 3": true,
              "Time 4": true,
              "Time 5": true,
              "Time 6": true,
              "Time 7": true
            },
            "indexByName": {
              "instance": 0,
              "Value #A": 1,
              "Value #B": 2,
              "Value #C": 3,
              "Value #D": 4,
              "Value #E": 5,
              "Value #F": 6,
              "Value #G": 7,
              "Value #H": 8
            },
            "renameByName": {
              "Value #A": "Run time",
              "Value #B": "CPU Frequency",
              "Value #C": "CPU Usage (%)",
              "Value #D": "Memory Usage (%)",
              "Value #E": "Root (/) Usage (%)",
              "Value #F": "Root (/) Free",
              "Value #G": "Data Free",
              "Value #H": "Number of Processes"
            }
          }
        }
      ],
      "type": "table",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "node_time_seconds - node_boot_time_seconds",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "node_cpu_frequency_hertz{cpu=\"0\"}",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "C"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "100 * (1 - ((node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes) / node_memory_MemTotal_bytes))",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "D"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "100 * (1 - (node_filesystem_free_bytes{mountpoint=\"/\"} / node_filesystem_size_bytes{mountpoint=\"/\"}))",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "E"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "node_filesystem_free_bytes{mountpoint=\"/\"}",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "F"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "node_filesystem_free_bytes{mountpoint=\"/data\"} or node_filesystem_free_bytes{mountpoint=\"/mnt\"}",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "G"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "${datasource}"
          },
          "editorMode": "code",
          "expr": "node_procs_running + node_procs_blocked",
          "format": "table",
          "instant": true,
          "legendFormat": "{{instance}}",
          "range": false,
          "refId": "H"
        }
      ]
    }
  ],
  "refresh": "10s",
  "schemaVersion": 38,
  "style": "dark",
  "tags": [
    "linux",
    "node-exporter"
  ],
  "templating": {
    "list": [
      {
        "current": {},
        "hide": 0,
        "includeAll": false,
        "label": "Data Source",
        "multi": false,
        "name": "datasource",
        "options": [],
        "query": "prometheus",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "type": "datasource"
      }
    ]
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "Linux Server Resources Overview",
  "version": 1
}```
