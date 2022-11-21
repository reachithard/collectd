#include "collectd.h"

#include "plugin.h"
#include "utils/common/common.h"

#include "libcapture.h"

#include <stdlib.h>

static void Process(enum CaptureAction action, const Process_t *processes,
                    uint32_t *size) {
  uint32_t tmp = *size;
  if (action == ACTION_REMOVE) {
    INFO("remove pid:%d", processes[0].pid);
  } else {
    for (uint32_t idx = 0; idx < tmp; idx++) {
      INFO("get pid:%d", processes[idx].pid);
      //   std::cout << "name:" << processes[idx].name
      //             << " cmdline:" << processes[idx].cmdline
      //             << " user:" << processes[idx].user
      //             << " group:" << processes[idx].group
      //             << " pid:" << processes[idx].pid
      //             << " uid:" << processes[idx].uid
      //             << " gid:" << processes[idx].gid
      //             << " fdCnt:" << processes[idx].fdCnt
      //             << " memory:" << processes[idx].memory
      //             << " cpuPercent:" << processes[idx].cpuPercent
      //             << " memPercent:" << processes[idx].memPercent
      //             << " ioRead:" << processes[idx].ioRead
      //             << " ioWrite:" << processes[idx].ioWrite
      //             << " recv:" << processes[idx].recv
      //             << " send:" << processes[idx].send;
      //   std::cout << std::endl;
      value_list_t vl = VALUE_LIST_INIT;

      value_t values[] = {
          {.gauge = processes[idx].uid},
          {.gauge = processes[idx].gid},
          {.gauge = processes[idx].fdCnt},
          {.gauge = processes[idx].memory},
          {.gauge = processes[idx].cpuPercent},
          {.gauge = processes[idx].memPercent},
          {.gauge = processes[idx].ioRead},
          {.gauge = processes[idx].ioWrite},
          {.gauge = processes[idx].recv},
          {.gauge = processes[idx].send},
      };

      char buffer[DATA_MAX_NAME_LEN] = "";
      vl.values = values;
      vl.values_len = STATIC_ARRAY_SIZE(values);
      sstrncpy(vl.host, processes[idx].name, sizeof(vl.host));
      sstrncpy(vl.plugin, "capture", sizeof(vl.plugin));
      snprintf(buffer, DATA_MAX_NAME_LEN, "%d", processes[idx].pid);
      sstrncpy(vl.plugin_instance, buffer, sizeof(vl.plugin));
      sstrncpy(vl.type, "capture", sizeof(vl.type));
      sstrncpy(vl.type_instance, processes[idx].user, sizeof(vl.type_instance));
      plugin_dispatch_values(&vl);

      value_list_t v2 = VALUE_LIST_INIT;
      value_t val = {.gauge = processes[idx].pid};
      v2.values = &val;
      v2.values_len = 1;

      sstrncpy(v2.host, processes[idx].name, sizeof(v2.host));
      sstrncpy(v2.plugin, "capture", sizeof(v2.plugin));
      sstrncpy(v2.plugin_instance, "pid", sizeof(v2.plugin));
      sstrncpy(v2.type, "pid", sizeof(v2.type));
      sstrncpy(v2.type_instance, processes[idx].user, sizeof(v2.type_instance));
      plugin_dispatch_values(&v2);
    }
  }
}

static void Packet(const Packet_t *packets, uint32_t *size) {
  uint32_t tmp = *size;
  // 打印包内容
  for (uint32_t idx = 0; idx < tmp; idx++) {
    INFO("get packet");
    // std::cout << "hash:" << packets[idx].hash
    //           << " family:" << packets[idx].family
    //           << " packetSize:" << packets[idx].packetSize;
    // std::cout << std::endl;
  }
}

static int capture_init(void) {
  CaptureInitt config;
  memset(&config, 0, sizeof(CaptureInitt));
  config.logfile = "./logs/exa_capture.log";
  config.ms = 100;
  config.snaplen = 100;

  int32_t ret = CaptureInit(&config, Process, Packet);
  return ret;
}

static int capture_config(oconfig_item_t *ci) /* {{{ */
{
  return 0;
} /* }}} int agg_config */

static int capture_read(void) {
  while (true) {
    /* code */
    CaptureUpdate(-1);
    sleep(3);
  }
  return 0;
}

void module_register(void) {
  plugin_register_init("capture", capture_init);
  plugin_register_complex_config("capture", capture_config);
  plugin_register_read("capture", capture_read);
}
