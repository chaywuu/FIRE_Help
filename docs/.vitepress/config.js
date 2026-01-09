export default {
  title: "FIRE火记手册",
  description: "",
  head: [
    ['link', { rel: 'icon', href: '/favicon.png' }],
  ],
  themeConfig: {
    search: {
      provider: 'local'
    },
    sidebar: {
      '/': [
        {
          text: '服务协议',
          items: [
            { text: '🔐 隐私政策', link: '/privacy' },
            { text: '👤 用户协议', link: '/user' }
          ]
        },
        {
          text: '关于我们',
          items: [
            { text: '🔄 版本更新', link: '/update' },
            { text: '🔥 关于我们', link: '/about' }
          ]
        }
      ]
    }
  }
}
